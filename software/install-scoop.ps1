# Install scoop

[net.webrequest]::defaultwebproxy = new-object net.webproxy $env:http_proxy
#[net.webrequest]::defaultwebproxy.credentials = new-object net.networkcredential 'user', 'pass'

if (Test-Path "${HOME}\scoop\shims\scoop.ps1") {
  scoop update
} else {
  Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
}

# scoop config proxy need to remove http://
$proxy_host = $env:http_proxy -replace '^http://','' -replace '/$',''
scoop config proxy $proxy_host