# Install and setup Jenkins swarm client at C:\jenkins
# https://github.com/jenkinsci/swarm-plugin
$swarm_client_version = '3.24'
$swarm_client_name = 'VS2019'
$swarm_client_home = 'C:\jenkins'
$swarm_sched_taskname = 'JenkinsSwarmClient'
if (Test-Path env:JENKINS_AGENT_LABELS) {
  $swarm_client_labels = $env:JENKINS_AGENT_LABELS
} else {
  $swarm_client_labels = 'build-vs2019'
}

if ((Test-Path env:JENKINS_URL) -and (Test-Path env:JENKINS_USER) -and (Test-Path env:JENKINS_TOKEN)) {
  $jenkins_url = $env:JENKINS_URL
  $jenkins_user = $env:JENKINS_USER
  $jenkins_token = $env:JENKINS_TOKEN
} else {
  Write-Warning "Skip the installation of jenkins-swarm-client because required variables are not set.`n(JENKINS_URL, JENKINS_USER and JENKINS_TOKEN)"
  exit 0
}

mkdir C:\jenkins\ -Force > $null

$swarm_client_download_url = "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${swarm_client_version}/swarm-client-${swarm_client_version}.jar"
Write-Output "Downloading ${swarm_client_download_url}"
Invoke-WebRequest -Uri $swarm_client_download_url -OutFile "${swarm_client_home}\swarm-client-${swarm_client_version}.jar"
$start_swarm_client_bat = @"
java -jar ${swarm_client_home}\swarm-client-${swarm_client_version}.jar ^
-name ${swarm_client_name} ^
-master ${jenkins_url} ^
-username ${jenkins_user} ^
-password ${jenkins_token} ^
-disableSslVerification ^
-executors 1 ^
-labels `"${swarm_client_labels}`" ^
-fsroot ${swarm_client_home}
"@
Write-Output $start_swarm_client_bat | Out-File "${swarm_client_home}\start-swarm-client.bat" -Encoding ascii -Force
Write-Output "Wrote ${swarm_client_home}\start-swarm-client.bat"

# Remove ScheduledTask if exist
if (Get-ScheduledTask -TaskName $swarm_sched_taskname -ErrorAction SilentlyContinue) {
  Unregister-ScheduledTask -TaskName $swarm_sched_taskname -Confirm:$false
}
# Set ScheduledTask to exec start-swarm-client.bat at the start of the machine (after next reboot)
$sched_user = New-ScheduledTaskPrincipal -UserId vagrant -LogonType Password
$sched_act  = New-ScheduledTaskAction -Execute "${swarm_client_home}\start-swarm-client.bat"
$sched_time = New-ScheduledTaskTrigger -AtStartup
$sched_task = New-ScheduledTask -Trigger $sched_time -Principal $sched_user -Action $sched_act
Register-ScheduledTask -InputObject $sched_task -TaskName $swarm_sched_taskname -User 'vagrant' -Password 'vagrant'
