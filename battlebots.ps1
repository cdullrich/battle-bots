# I lost track of the full requirements, but I created a robot battle simulator using WEAPON_POWER * (ARMOR_THICKNESS / BOT_WEIGHT) to determine power
# This scripts allows users to choose a robot (including a random option) and an opponent to fight in an arena

#region convert csv files
#we did this on our call today
$dataset1 = @"
NAME,BOT_WEIGHT,TYPE
Slasher,1.4,melee
Blaster,0.72,ranged
Stomper,1.8,melee
Shielder,0.47,melee
Tanker,2.6,melee
Sniper,1.50,ranged
Destroyer,6.5,melee
"@

$dataset1Objects = $dataset1 | ConvertFrom-Csv

$dataset2 = @"
NAME,WEAPON_POWER,ARMOR_THICKNESS
Tanker,1.97,0.5
Sniper,1.70,0.3
Destroyer,4.76,0.7
Slasher,1.3,0.4
Blitz,1.11,0.2
Blaster,1.24,0.3
Stomper,2.62,0.6
Shielder,1.2,0.35
"@

$dataset2Objects = $dataset2 | ConvertFrom-Csv
#endregion

#region merge csv data
#This section matches data between csv files using NAME as a common key
$combinedDataset = $dataset1Objects | ForEach-Object {
    $robot = $_
    $match = $dataset2Objects | Where-Object { $_.NAME -eq $robot.NAME }
    [PSCustomObject]@{
        NAME = $robot.NAME
        BOT_WEIGHT = [float]$robot.BOT_WEIGHT #Hit an issue here as these values were defaulting to strings. Changing data type fixed this.
        TYPE = $robot.TYPE
        WEAPON_POWER = [float]$match.WEAPON_POWER
        ARMOR_THICKNESS = [float]$match.ARMOR_THICKNESS
    }
}
#endregion

#region calculate power levels
# Create an empty object to fill with power levels
$powerTable = @{}

#use the algorithm for power level and store values in the powerTable
foreach ($robot in $combinedDataset) {
    $powerlevel = $robot.WEAPON_POWER * ($robot.ARMOR_THICKNESS / $robot.BOT_WEIGHT)
    $powerTable[$robot.NAME] = $powerlevel
}
#endregion

#region robot select
#Define possible options. I realize now I could have just listed these from the object, but oops. Would refactor in a real environment.
$robotOptions = "Sniper", "Tanker", "Shielder", "Destroyer", "Blaster", "Stomper", "Slasher", "Random"

# Loop until the user enters a valid option
do {
    $myOption = Read-Host "Choose your fighter: $($robotOptions -join ', ')"
    if($myOption -notin $robotOptions){
    Write-Host "$myOption is not in the list of available robots. Please try again" -ForegroundColor Red
    }
}
while ($myOption -notin $robotOptions)

#This gives a "Random" option to the user and the do loop is to prevent it from being assigned "Random" as a final robot name
if($myOption -eq "Random"){
    do{
        $myOption = Get-Random -InputObject $robotOptions
    }
    until ($myOption -ne "Random")
}

Write-Host "`n Your fighter is: $myOption `n"

do {
    $enemyOption = Read-Host "Choose your opponent: $($robotOptions -join ', ')"
    if($enemyOption -notin $robotOptions){
    Write-Host "$enemyOption is not in the list of available robots. Please try again" -ForegroundColor Red
    }
}
while ($enemyOption -notin $robotOptions)

if($enemyOption -eq "Random"){
    do{
        $enemyOption = Get-Random -InputObject $robotOptions
    }
    Until ($enemyOption -ne "Random")
}
#endregion

#Assign power levels based on selected robot
$myPower = $powerTable[$myOption]
$enemyPower = $powerTable[$enemyOption]

#region battle
# Just being theatrical here. Scripting can be fun!
Write-Host "`n You choose to fight: $enemyOption `n"

sleep 2

Write-Host "LET THE BATTLE BEGIN!" -ForegroundColor Red

sleep 2

Write-Host "BOOM!"

Sleep 2

Write-Host "BANG!"

Sleep 2

Write-Host "BLORP!"

sleep 2

# Reveal power levels (over 9000!)
Write-Host "`n With $myOption at a power level of $myPower and $enemyOption at a power level of $enemyPower... `n"

sleep 2

#Reveal a win/loss/tie
if($myPower -gt $enemyPower){
    Write-Host "`n Your robot $myOption has bested $enemyOption in glorious robot battle! `n" -ForegroundColor Green
}
elseif($myPower -lt $enemyPower){
    Write-Host "`n The crowd goes silent as your robot $myOption falls crackling at the wheels of $enemyOption `n Better luck next time... `n" -ForegroundColor Red
}
elseif($myPower -eq $enemyPower){
    Write-Host "`n Both robots go down in a heap of smoke with no true victor..." -ForegroundColor Yellow
    sleep 2
    Write-host "ONLY CARNAGE! `n" -ForegroundColor Red
}
#endregion

# I end interactive powershell scripts with a Read-Host so they don't automatically close when run from a file browser
Read-Host "Press enter to leave the robot colisuem"
