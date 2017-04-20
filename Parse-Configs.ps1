class Inventory2 {
    [string] $Server;
    [string] $FileName;
    [string[]] $Connections;

    Inventory2([string]$server, [string]$fileName){
        $this.Server = $server;
        $this.FileName = $fileName;
        $this.Connections = @()
    }

    
    Inventory2([string]$server, [string]$fileName, [string[]]$conn){
        $this.Server = $server;
        $this.FileName = $fileName;
        $this.Connections = $conn;
    }

    [void] Add([string]$value){
        $this.Connections += $value
    }
}

$FolderPath = "C:\users\Fenil\Downloads\Configs\MES\Web.config"
$configs = Get-ChildItem -Path $FolderPath -Recurse -Filter "*.config"
foreach ($config in $configs){
$c = (Get-Content $config.FullName)

$connections = @()
$connections += ($c -match "\\\\\w+");
$connections += ($c -match "Server=");
$connections += ($c -match "Data Source=");
$connections += ($c -match "http:");
$connections += ($c -match "https:");
$connectionsupdated = @()
foreach($val in $connections){
    try{
        $xmlVal = [xml]$val
        if($xmlVal.add.Value){$connectionsupdated += $xmlVal.add.value}
        if($xmlVal.add.server){$connectionsupdated += $xmlVal.add.server}
        if($xmlVal.add.connectionString){$connectionsupdated += $xmlVal.add.connectionString}
        if($xmlVal.endpoint){$connectionsupdated += $xmlVal.endpoint.address}
        if($xmlVal.sessionState){$connectionsupdated += $xmlVal.sessionState.sqlConnectionString}
        if($xmlVal.value){$connectionsupdated += $xmlVal.value}
    }
    catch{
        $val += " />"
        $xmlVal = [xml]$val
        if($xmlVal.add.Value){$connectionsupdated += $xmlVal.add.value}
        if($xmlVal.add.server){$connectionsupdated += $xmlVal.add.server}
        if($xmlVal.add.connectionString){$connectionsupdated += $xmlVal.add.connectionString}
        if($xmlVal.endpoint){$connectionsupdated += $xmlVal.endpoint.address}
        if($xmlVal.sessionState){$connectionsupdated += $xmlVal.sessionState.sqlConnectionString}
        if($xmlVal.value){$connectionsupdated += $xmlVal.value}
    }
    
}

$config.FullName
Write-Host "diff btw old : updated -- $($connections.Count) : $($connectionsupdated.Count)"
$connections
Write-Host "items in updated $($connectionsupdated.Count)"
$connectionsupdated

$inventory2 = [Inventory2]::new($env:ComputerName, $config.FullName,$connectionsupdated)


}