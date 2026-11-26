20. Boot e Inicialização do Sistema

O processo de boot é uma cascata de etapas, cada uma preparando o ambiente para a próxima.

Etapa 1: Firmware (BIOS/UEFI)
O computador liga. A CPU executa o código embutido na placa-mãe (firmware).

**BIOS (Basic Input/Output System):**
- Código de 16 bits muito antigo.
- Inicializa hardware básico (RAM, teclado, disco).
- Procura por um dispositivo inicializável (disco, pendrive).
- Lê o primeiro setor (512 bytes) do disco (Master Boot Record - MBR).
- Executa o código no MBR.

**UEFI (Unified Extensible Firmware Interface):**
- Firmware moderno, 64-bit.
- Procura pela partição EFI System Partition (ESP).
- Lê o bootloader da ESP.
- Executa o bootloader.

Etapa 2: Bootloader (GRUB)
O bootloader é um programa pequeno cuja única função é encontrar o kernel Linux no disco, carregá-lo na memória RAM e passar o controle para ele.