class Database {
    [string] $Key;
    [string] $Server;
    [string] $Database;

    Database(){}

    Database([string]$key, [string] $server, [string] $database){
        $this.Key = $key;
        $this.Server = $server;
        $this.Database = $database;
    }
}

class AppConnection {
    [string] $Key;
    [string] $Connection;

    AppConnection(){}

    AppConnection([string]$key, [string]$connection){
        $this.Key = $key;
        $this.Connection = $connection;
    }
}

class Inventory {
    [string] $Name;
    [Database[]] $DBConnections;
    [AppConnection[]] $AppConnections;
    
    Inventory([string]$name){
        $this.Name = $name;
        [Database]::new();
        [AppConnection]::new();
    }

    Inventory ([Database[]]$dbs,[AppConnection[]]$endpoints) {
        $this.DBConnections = $dbs;
        $this.AppConnections = $endpoints;
    }



    [void] AddDb([Database]$db){
        $this.DBConnections += $db
    }

    [void] AddApp([AppConnection]$endpoint){
        $this.AppConnections += $endpoint
    }
}


function Parse-ConfigFiles {
    param([string]$FolderPath = "C:\Users\Fenil\Downloads\Configs\RTGE Edits")

    Begin {

    }

    Process {
        $configs = Get-ChildItem -Path $FolderPath -Filter "*.config"

        $inventory = [Inventory]::new($FolderPath);

        foreach ($config in $configs) {
            $filePath = $config.FullName
            $filePath

            $c = [xml](Get-Content $filePath)

            
            foreach($setting in $c.appSettings.add){
                if($setting.value -match "Server="){
                    $key = $setting.key
                    $server = $setting.value.split(";") -match "Server=" | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Server"}
                    $database = $setting.value.split(";") -match "Database="  | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Database"}
                    $inventory.AddDb([Database]::new($key,$server,$database))
                }

                if($setting.value -match "Source="){
                    $key = $setting.key
                    $server = $setting.value.split(";") -match "Data Source=" | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Data Source"}
                    $database = $setting.value.split(";") -match "Initial Catalog="  | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Initial Catalog"}
                    $inventory.AddDb([Database]::new($key,$server,$database))
                }

                if(($setting.value -match 'http:') -or ($setting.value -match 'https:') -or ($settings.value -match 'tcp:') -or ($settings.value -match '\\\\\w+')){
                    $key = $setting.key
                    $conn = $setting.value
                    $inventory.AddApp([AppConnection]::new($key,$conn))
                }
            }
            

            foreach($connString in $c.connectionStrings.add){
                if($connString.connectionString -match "Server="){
                    $key = $connString.name
                    $server = $connString.connectionString.split(";") -match "Server=" | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Server"}
                    $database = $connString.connectionString.split(";") -match "Database="  | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Database"}
                    $inventory.AddDb([Database]::new($key,$server,$database))
                }

                if($connString.connectionString -match "Source="){
                    $key = $connString.name
                    $server = $connString.connectionString.split(";") -match "Data Source=" | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Data Source"}
                    $database = $connString.connectionString.split(";") -match "Initial Catalog="  | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Initial Catalog"}
                    $inventory.AddDb([Database]::new($key,$server,$database))
                }

                if(($connString.connectionString -match 'http:') -or ($connString.connectionString -match 'https:') -or ($connString.connectionString -match 'tcp:')){
                    $key = $connString.name
                    $conn = $connString.connectionString
                    $inventory.AddApp([AppConnection]::new($key,$conn))
                }
            }
            

            foreach($client in $c.client.endpoint){
                $key = $client.contract
                $endpoint = $client.address
                $inventory.AddApp([AppConnection]::new($key,$endpoint));
            }

            foreach($ems in $c.EmsConnections.connections.add){
                $key = $ems.name
                $server = $ems.server
                $inventory.AddApp([AppConnection]::new($key,$server));
            }

            foreach($setting in $c.configuration.appSettings.add){
                if($setting.value -match "Server="){
                    $key = $setting.key
                    $server = $setting.value.split(";") -match "Server=" | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Server"}
                    $database = $setting.value.split(";") -match "Database="  | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Database"}
                    $inventory.AddDb([Database]::new($key,$server,$database))
                }

                if($setting.value -match "Source="){
                    $key = $setting.key
                    $server = $setting.value.split(";") -match "Data Source=" | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Data Source"}
                    $database = $setting.value.split(";") -match "Initial Catalog="  | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Initial Catalog"}
                    $inventory.AddDb([Database]::new($key,$server,$database))
                }

                if(($setting.value -match 'http:') -or ($setting.value -match 'https:') -or ($settings.value -match 'tcp:') -or ($settings.value -match '\\\\\w+')){
                    $key = $setting.key
                    $conn = $setting.value
                    $inventory.AddApp([AppConnection]::new($key,$conn))
                }
            }
            

            foreach($connString in $c.configuration.connectionStrings.add){
                if($connString.connectionString -match "Server="){
                    $key = $connString.name
                    $server = $connString.connectionString.split(";") -match "Server=" | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Server"}
                    $database = $connString.connectionString.split(";") -match "Database="  | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Database"}
                    $inventory.AddDb([Database]::new($key,$server,$database))
                }

                if($connString.connectionString -match "Source="){
                    $key = $connString.name
                    $server = $connString.connectionString.split(";") -match "Data Source=" | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Data Source"}
                    $database = $connString.connectionString.split(";") -match "Initial Catalog="  | ForEach-Object {$_ -split "="} | Where-Object {$_ -ne "Initial Catalog"}
                    $inventory.AddDb([Database]::new($key,$server,$database))
                }

                if(($connString.connectionString -match 'http:') -or ($connString.connectionString -match 'https:') -or ($connString.connectionString -match 'tcp:')){
                    $key = $connString.name
                    $conn = $connString.connectionString
                    $inventory.AddApp([AppConnection]::new($key,$conn))
                }
            }
            

            foreach($client in $c.configuration.system.serviceModel.client.endpoint){
                $key = $client.contract
                $endpoint = $client.address
                $inventory.AddApp([AppConnection]::new($key,$endpoint));
            }

            foreach($ems in $c.configuration.EmsConnections.connections.add){
                $key = $ems.name
                $server = $ems.server
                $inventory.AddApp([AppConnection]::new($key,$server));
            }
             
        }

        #$inventory | Format-Table
        $inventory | ConvertTo-Json

    }

    End {

    }

}

Parse-ConfigFiles