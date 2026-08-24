# El Pañalómetro de Violeta 🌸💩

App para trackear el uso de pañales de nuestra hija Violeta Esperanza — registrar cada cambio, cada compra, y ver cuánto stock queda por talla con alertas de bajo stock.

## Features

- **Quick-log buttons** — un tap para registrar un cambio de pañal por talla
- **Stock por talla** — pañales disponibles, uso promedio diario, días estimados restantes
- **Alertas de bajo stock** — aviso cuando quedan ≤3 días de pañales
- **Historial** — registro completo de cambios y compras
- **Turbo Streams** — actualizaciones en tiempo real sin recargar la página
- **Tema día/noche** — toggle manual con persistencia en localStorage
- **Contador de vida** — días/semanas/meses desde que nació Violeta
- **Mensajes de ánimo** — frases random para padres cansados

## Stack

- **Rails 8.1** con SQLite (sin Redis/Postgres)
- **Hotwire** (Turbo + Stimulus)
- **Solid Queue/Cache/Cable** para jobs, cache y websockets
- **Kamal** para deploy
- **CSS neobrutalist** hecho a mano (sin Tailwind/Bootstrap)

## Setup

```bash
bin/setup
```

Esto instala gems, prepara la base de datos y limpia logs/tmp.

## Desarrollo

```bash
# Servidor (puerto 3000 por defecto)
bin/dev

# O en otro puerto
PORT=3001 bin/dev

# Consola Rails
bin/rails console

# Tests
bundle exec rspec

# Lint
bin/rubocop

# CI completo (lo mismo que corre GitHub Actions)
bin/ci
```

## Comandos útiles

```bash
# Un archivo de specs
bundle exec rspec spec/models/diaper_change_spec.rb

# Un ejemplo específico
bundle exec rspec spec/models/diaper_change_spec.rb:12

# Autocorregir lint
bin/rubocop -a

# Security scans
bin/brakeman --no-pager
bin/bundler-audit
bin/importmap audit
```

## Deploy

Configurado con Kamal. Los datos persisten en un volumen Docker (`cacacounter_storage`).

```bash
bin/kamal deploy
bin/kamal console
bin/kamal logs
```

## Modelo de datos

- `DiaperChange` — cada cambio de pañal (talla, fecha/hora, notas opcionales)
- `DiaperPurchase` — cada compra (talla, cantidad, marca opcional, notas)
- `DiaperStockSummary` — cálculos de stock, uso promedio y alertas (no es ActiveRecord)
- `DiaperSize::OPTIONS` — tallas válidas: RN, P, M, G, XG, XXG

---

Hecho con amor para Violeta 💜
