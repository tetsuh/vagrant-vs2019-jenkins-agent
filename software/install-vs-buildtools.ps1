Write-Host "Installing Build Tools for Visual Studio 2019. This may take a while..."
$exe = Get-ChildItem -Path C:\vagrant\software\vs_buildtools_*.exe -File | Select-Object Name
Start-Process -FilePath "C:\vagrant\software\$($exe.Name)" -Wait -ArgumentList `
  '--wait','--passive','--norestart', `
  '--addProductLang','en-US', `
  '--add', 'Microsoft.VisualStudio.Workload.MSBuildTools', `
  '--add', 'Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools', `
  '--add', 'Microsoft.Net.ComponentGroup.4.8.DeveloperTools', `
  '--add', 'Microsoft.VisualStudio.Workload.NetCoreBuildTools', `
  '--add', 'Microsoft.VisualStudio.Workload.VCTools;includeRecommended;includeOptional', `
  '--remove', 'Microsoft.VisualStudio.Component.Windows10SDK.16299', `
  '--remove', 'Microsoft.VisualStudio.Component.Windows10SDK.17134', `
  '--remove', 'Microsoft.VisualStudio.Component.VC.140'

# prevent msbuild from running in background, as that will interfere with
# cleaning the job workspace due to open files/directories.
[Environment]::SetEnvironmentVariable(
    'MSBUILDDISABLENODEREUSE',
    '1',
    'Machine')
