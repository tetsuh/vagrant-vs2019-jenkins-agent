# This script is partially borrowed by referencing the files in the following repository.
# https://github.com/rgl/jenkins-vagrant/blob/master/windows/provision-vs-build-tools.ps1

# install the Visual Studio Build Tools 2017 15.9.
# see https://www.visualstudio.com/downloads/
# see https://docs.microsoft.com/en-us/visualstudio/releasenotes/vs2017-relnotes-history
# see https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2017
# see https://docs.microsoft.com/en-us/visualstudio/install/command-line-parameter-examples?view=vs-2017
# see https://docs.microsoft.com/en-us/visualstudio/install/workload-and-component-ids?view=vs-2017
# see https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2017
# To get the download URL, peek at the download link directly in the browser developer tools
# https://docs.microsoft.com/ja-jp/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2017
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2017
# https://aka.ms/vs/15/release/vs_buildtools.exe
$archiveUrl = 'https://download.visualstudio.microsoft.com/download/pr/b8d403d9-01a4-45a0-9229-db5572fd5e4e/997600ae09705dfc6d069d8ad2cfad1962d8ff6fedd6c9fe5abee36c7c919f34/vs_BuildTools.exe'
$archiveHash = '997600ae09705dfc6d069d8ad2cfad1962d8ff6fedd6c9fe5abee36c7c919f34'

$archiveName = Split-Path $archiveUrl -Leaf
$archivePath = "C:\tmp\$archiveName"
Write-Host 'Downloading the Visual Studio Build Tools Setup Bootstrapper...'
(New-Object Net.WebClient).DownloadFile($archiveUrl, $archivePath)
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveHash -ne $archiveActualHash) {
    throw "$archiveName downloaded from $archiveUrl to $archivePath has $archiveActualHash hash witch does not match the expected $archiveHash"
}

Write-Host "Installing Build Tools for Visual Studio 2017. This may take a while..."
Start-Process -FilePath $archivePath -Wait -ArgumentList `
  '--wait','--passive','--norestart', `
  '--addProductLang','en-US', `
  '--add', 'Microsoft.VisualStudio.Workload.MSBuildTools', `
  '--add', 'Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools', `
  '--add', 'Microsoft.Net.Component.4.TargetingPack', `
  '--add', 'Microsoft.VisualStudio.Workload.NetCoreBuildTools', `
  '--add', 'Microsoft.VisualStudio.Workload.VCTools;includeRecommended',
  '--add', 'Microsoft.Component.VC.Runtime.UCRTSDK',
  '--add', 'Microsoft.VisualStudio.Component.VC.ATL',
  '--add', 'Microsoft.VisualStudio.Component.VC.ATLMFC',
  '--add', 'Microsoft.VisualStudio.Component.VC.CLI.Support'

# prevent msbuild from running in background, as that will interfere with
# cleaning the job workspace due to open files/directories.
[Environment]::SetEnvironmentVariable(
    'MSBUILDDISABLENODEREUSE',
    '1',
    'Machine')
