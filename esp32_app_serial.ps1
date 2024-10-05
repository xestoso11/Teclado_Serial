# Define las funciones para simular pulsaciones de teclas
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    public const int KEYEVENTF_KEYUP = 0x2;

    public static void KeyDown(byte keyCode) {
        keybd_event(keyCode, 0, 0, UIntPtr.Zero); // No usar KEYEVENTF_EXTENDEDKEY para teclas estándar
    }

    public static void KeyUp(byte keyCode) {
        keybd_event(keyCode, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
    }

    public static void PressKey(byte keyCode) {
        KeyDown(keyCode);
        KeyUp(keyCode);
    }
}
"@

# Mapa de teclas para el teclado numérico
$charToKeyCode = @{
    '1' = 0x31
    '2' = 0x32
    '3' = 0x33
    '4' = 0x34
    '5' = 0x35
    '6' = 0x36
    '7' = 0x37
    '8' = 0x38
    '9' = 0x39
    '0' = 0x30
    'A' = 0x41
    'B' = 0x42
    'C' = 0x43
    'D' = 0x44
    'G' = 0x47
    'H' = 0x48
    'U' = 0x55
    'V' = 0x56
    'J' = 0x4A
    'K' = 0x4B
}

# Códigos de teclas para CTRL, SHIFT, ALT
$VK_CTRL = 0x11
$VK_SHIFT = 0x10
$VK_ALT = 0x12

# Configurar el puerto serial
$portName = "COM3" # Cambia esto al puerto correcto
$baudRate = 115200
$serialPort = new-Object System.IO.Ports.SerialPort $portName, $baudRate, None, 8, one

try {
    $serialPort.Open()
    Write-Host "Puerto serial abierto exitosamente."
} catch {
    Write-Host "Error al abrir el puerto serial: $_"
    exit 1
}

while ($serialPort.IsOpen) {
    try {
        $line = $serialPort.ReadLine()
        if ($line.StartsWith("KEY:")) {
            $key = $line.Substring(4).Trim()
            if ($charToKeyCode.ContainsKey($key)) {
                $keyCode = [byte]$charToKeyCode[$key]

                # Presionar CTRL, SHIFT, ALT
                [Keyboard]::KeyDown($VK_CTRL)
                Start-Sleep -Milliseconds 50
                [Keyboard]::KeyDown($VK_SHIFT)
                Start-Sleep -Milliseconds 50
                [Keyboard]::KeyDown($VK_ALT)
                Start-Sleep -Milliseconds 50

                # Presionar la tecla específica
                [Keyboard]::PressKey($keyCode)
                Write-Host "Presionando: $key"
                Start-Sleep -Milliseconds 100

                # Liberar CTRL, SHIFT, ALT
                [Keyboard]::KeyUp($VK_ALT)
                Start-Sleep -Milliseconds 50
                [Keyboard]::KeyUp($VK_SHIFT)
                Start-Sleep -Milliseconds 50
                [Keyboard]::KeyUp($VK_CTRL)
                Write-Host "Teclas liberadas."
            }
        }
    } catch {
        Write-Host "Error al leer del puerto serial: $_"
    }
    Start-Sleep -Milliseconds 100
}

$serialPort.Close()
Write-Host "Puerto serial cerrado."