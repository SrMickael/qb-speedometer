# qb-speedometer

**Descrição:** HUD circular de velocímetro em **NUI (HTML/CSS/JS)** para servidores **FiveM QBCore**. Exibe a velocidade atual do veículo em km/h ou mph, com indicadores de combustível, motor, cinto de segurança, nitro e até um consumível extra configurável (ex: água, óleo, coolant).

---

## 🚀 Instalação

1. Copie a pasta `qb-speedometer` para o diretório `resources` do seu servidor.
2. No arquivo `server.cfg`, adicione a linha:

   ```
   ensure qb-speedometer
   ```
3. Configure as opções desejadas em `config.lua`.

---

## ⚙️ Configuração (config.lua)

* **Position / Scale:** posição e escala do HUD na tela.
* **Unit:** `KMH` ou `MPH`.
* **Alertas:** thresholds para combustível baixo e motor danificado.
* **SmoothFactor:** suavização de ponteiros e display.
* **Ícones:** habilite/desabilite cinto, combustível, motor, nitro e consumível extra.
* **Hotkey:** comando configurável (`togglespeedo`) com suporte a `RegisterKeyMapping`.
* **Compatibilidade:** suporta múltiplos recursos de combustível (`qb-fuel`, `LegacyFuel`) e nitro (`ps-nitro`, `cw-nitro`).
* **Consumível Extra:** função customizada que pode retornar nível em % ou `nil` para ocultar.

---

## 🎮 Funcionalidades

* HUD circular em NUI para velocímetro.
* Unidades configuráveis (KMH/MPH).
* Indicadores de combustível, motor e nitro.
* Ícone de cinto de segurança.
* Suporte para um consumível extra (água, óleo, coolant).
* Opção para mostrar/ocultar com hotkey.

---

## 📦 Requisitos

* FiveM
* QBCore Framework
* Recurso de combustível (ex: qb-fuel ou LegacyFuel)
* Recurso de nitro (opcional: ps-nitro, cw-nitro)

---

## 🧑‍💻 Autor

Feito com ❤️ para a comunidade FiveM.

---

## 📜 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
