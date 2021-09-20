# This script is partially borrowed by referencing the files in the following repository.
# https://github.com/rgl/jenkins-vagrant/blob/master/windows/provision-vs-build-tools.ps1

# install the Visual Studio Build Tools 2019 16.11.
# see https://www.visualstudio.com/downloads/
# see https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes
# see https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2019
# see https://docs.microsoft.com/en-us/visualstudio/install/command-line-parameter-examples?view=vs-2019
# see https://docs.microsoft.com/en-us/visualstudio/install/workload-and-component-ids?view=vs-2019
# see https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2019
# To get the download URL, peek at the download link directly in the browser developer tools
# https://docs.microsoft.com/ja-jp/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2019
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019
# https://aka.ms/vs/16/release/vs_buildtools.exe
$archiveUrl = 'https://download.visualstudio.microsoft.com/download/pr/22c17f05-944c-48dc-9f68-b1663f9df4cb/07fb37cabe09c87604aebd60daa829e12aa4e75e4d973f6961bd71f36f0e8b11/vs_BuildTools.exe'
$archiveHash = '07fb37cabe09c87604aebd60daa829e12aa4e75e4d973f6961bd71f36f0e8b11'
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
  '--add', 'Microsoft.Net.ComponentGroup.4.8.DeveloperTools', `
  '--add', 'Microsoft.Net.Component.4.TargetingPack', `
  '--add', 'Microsoft.VisualStudio.Workload.NetCoreBuildTools', `
  '--add', 'Microsoft.VisualStudio.Workload.VCTools;includeRecommended', `
  '--add', 'Microsoft.Component.VC.Runtime.UCRTSDK', `
  '--add', 'Microsoft.Net.Component.4.8.SDK', `
  '--add', 'Microsoft.VisualStudio.Component.VC.ATL', `
  '--add', 'Microsoft.VisualStudio.Component.VC.ATLMFC', `
  '--add', 'Microsoft.VisualStudio.Component.VC.CLI.Support', `
  '--add', 'Microsoft.VisualStudio.Component.Windows10SDK.17763'

# prevent msbuild from running in background, as that will interfere with
# cleaning the job workspace due to open files/directories.
[Environment]::SetEnvironmentVariable(
    'MSBUILDDISABLENODEREUSE',
    '1',
    'Machine')
