# This script is partially borrowed by referencing the files in the following repository.
# https://github.com/rgl/jenkins-vagrant/blob/master/windows/provision-vs-build-tools.ps1

# install the Visual Studio Build Tools 2022 17.2.
# see https://www.visualstudio.com/downloads/
# see https://docs.microsoft.com/en-us/visualstudio/releases/2022/release-notes
# see https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022
# see https://docs.microsoft.com/en-us/visualstudio/install/command-line-parameter-examples?view=vs-2022
# see https://docs.microsoft.com/en-us/visualstudio/install/workload-and-component-ids?view=vs-2022
# see https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022
# To get the download URL, peek at the download link directly in the browser developer tools
# https://docs.microsoft.com/ja-jp/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2022
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2022
# https://aka.ms/vs/17/release/vs_buildtools.exe
$archiveUrl = 'https://download.visualstudio.microsoft.com/download/pr/05734053-383e-4b1a-9950-c7db8a55750d/fbfc005ace3e6b4990e9a4be0fa09e7face1af5ee1f61035c64dbc16c407aeda/vs_BuildTools.exe'
$archiveHash = 'FBFC005ACE3E6B4990E9A4BE0FA09E7FACE1AF5EE1F61035C64DBC16C407AEDA'
$archiveName = Split-Path $archiveUrl -Leaf
$archivePath = "C:\tmp\$archiveName"
Write-Host 'Downloading the Visual Studio Build Tools Setup Bootstrapper...'
(New-Object Net.WebClient).DownloadFile($archiveUrl, $archivePath)
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveHash -ne $archiveActualHash) {
    throw "$archiveName downloaded from $archiveUrl to $archivePath has $archiveActualHash hash witch does not match the expected $archiveHash"
}

Write-Host "Installing Build Tools for Visual Studio 2019. This may take a while..."
Start-Process -FilePath $archivePath -Wait -ArgumentList `
  '--wait','--passive','--norestart', `
  '--addProductLang','en-US', `
  '--add', 'Microsoft.VisualStudio.Workload.MSBuildTools', `
  '--add', 'Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools', `
  '--add', 'Microsoft.NetCore.Component.SDK', `
  '--add', 'Microsoft.Net.ComponentGroup.4.8.DeveloperTools', `
  '--add', 'Microsoft.Net.Component.4.TargetingPack', `
  '--add', 'Microsoft.VisualStudio.Workload.NetCoreBuildTools', `
  '--add', 'Microsoft.VisualStudio.Workload.VCTools;includeRecommended', `
  '--add', 'Microsoft.Component.VC.Runtime.UCRTSDK', `
  '--add', 'Microsoft.Net.Component.4.8.SDK', `
  '--add', 'Microsoft.VisualStudio.Component.VC.ATL', `
  '--add', 'Microsoft.VisualStudio.Component.VC.ATLMFC', `
  '--add', 'Microsoft.VisualStudio.Component.VC.CLI.Support'

# prevent msbuild from running in background, as that will interfere with
# cleaning the job workspace due to open files/directories.
[Environment]::SetEnvironmentVariable(
    'MSBUILDDISABLENODEREUSE',
    '1',
    'Machine')
