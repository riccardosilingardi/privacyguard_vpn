# 🚀 Script Deploy Cloudflare VPN

## ✅ SETUP AUTOMATICO AL 100%

Questo script configura **TUTTO** automaticamente per avere la VPN funzionante al 100%.

---

## 📋 COSA SERVE DA TE (5 MINUTI)

### Input Minimo:

1. **Cloudflare API Token**
   - Vai su: https://dash.cloudflare.com/profile/api-tokens
   - Click "Create Token"
   - Use template: "Edit Cloudflare Workers"
   - Click "Continue to summary" → "Create Token"
   - **COPIA IL TOKEN** (lo vedi solo una volta!)

2. **Account ID**
   - Dashboard Cloudflare: https://dash.cloudflare.com
   - Seleziona un sito qualsiasi (o Workers & Pages)
   - Lato destro → **Account ID**
   - Copia

3. **Zone ID** (opzionale)
   - Solo se hai un dominio
   - Dashboard → Seleziona dominio
   - Overview → **Zone ID**
   - Copia

**SOLO QUESTI 2-3 VALORI!** Lo script fa tutto il resto.

---

## 🎯 COSA FA LO SCRIPT

### Automaticamente:

1. ✅ **Registra device WARP** su Cloudflare
2. ✅ **Genera chiavi WireGuard** client/server
3. ✅ **Crea configurazione VPN** completa
4. ✅ **Deploy Cloudflare Worker** per tracker blocking
5. ✅ **Genera file Flutter** con config
6. ✅ **Aggiunge server a Convex** (se disponibile)
7. ✅ **VPN PRONTA AL 100%!**

### Output:

- `config/warp_vpn.conf` - WireGuard config testabile
- `lib/core/config/cloudflare_vpn_config.dart` - Config Flutter
- `workers/tracker-blocker.js` - Worker per blocco tracker
- `.env` - Variabili ambiente

---

## 🚀 ESECUZIONE

### Metodo 1: Interattivo (Consigliato)

```bash
cd /home/user/privacyguard_vpn

./scripts/deploy_cloudflare_vpn.sh

# Lo script chiederà:
# - Cloudflare API Token: [incolla token]
# - Account ID: [incolla ID]
# - Zone ID: [premi Enter se non hai dominio]

# Poi fa TUTTO automaticamente!
```

### Metodo 2: Con .env preconfigurato

```bash
# Crea .env manualmente
cat > .env <<EOF
CF_API_TOKEN=your_token_here
CF_ACCOUNT_ID=your_account_id_here
CF_ZONE_ID=
EOF

# Esegui script
./scripts/deploy_cloudflare_vpn.sh
```

---

## 📊 DOPO LO SCRIPT

### Verifica tutto funziona:

```bash
# 1. Testa config WireGuard (opzionale)
cat config/warp_vpn.conf

# 2. Verifica Flutter config
cat lib/core/config/cloudflare_vpn_config.dart

# 3. Deploy Worker (se non fatto automaticamente)
cd workers
wrangler login
wrangler deploy
cd ..

# 4. Deploy Convex (se non fatto)
npx convex dev

# 5. Test app
flutter run -d android

# Login: test@example.com / password123
# Tap "Connect"
# ✅ VPN FUNZIONA!
```

---

## 🎯 ARCHITETTURA FINALE

```
Flutter App
    ↓
Cloudflare WARP (VPN globale)
    ↓
Cloudflare Worker (Tracker Blocking)
    ↓
Cloudflare Analytics (Privacy Score + ICR)
    ↓
Convex (Database + Sessions)
```

**Tutto gratis e scalabile!**

---

## ✅ VANTAGGI CLOUDFLARE

| Feature | Valore |
|---------|--------|
| **Costo** | $0 (gratis per sempre) |
| **Bandwidth** | Illimitato |
| **Locations** | 300+ data center |
| **Latency** | <20ms media |
| **Tracker Blocking** | Integrato via Worker |
| **Analytics** | Gratis e privacy-compliant |
| **Manutenzione** | Zero (managed) |
| **Setup Time** | 5 minuti |

---

## 🐛 TROUBLESHOOTING

### Errore: "WARP registration failed"

```bash
# Riprova registrazione
curl -X POST https://api.cloudflareclient.com/v0a2158/reg \
  -H "Content-Type: application/json" \
  -d '{"key":"test","install_id":"","fcm_token":"","tos":"2024-01-01T00:00:00Z","type":"Android","locale":"en_US"}'
```

### Errore: "Wrangler not found"

```bash
npm install -g wrangler
```

### Errore: "Permission denied"

```bash
chmod +x scripts/deploy_cloudflare_vpn.sh
```

### Worker deploy fallisce

```bash
cd workers
wrangler login  # Login manuale
wrangler deploy
```

---

## 📚 DOCUMENTAZIONE

- Cloudflare WARP: https://developers.cloudflare.com/warp-client/
- Cloudflare Workers: https://developers.cloudflare.com/workers/
- WireGuard: https://www.wireguard.com/
- Convex: https://docs.convex.dev/

---

## 🎉 RISULTATO FINALE

Dopo aver eseguito lo script avrai:

✅ VPN Cloudflare WARP funzionante
✅ WireGuard config generato
✅ Tracker blocking attivo
✅ Analytics privacy-compliant
✅ ICR rewards calcolabili
✅ App Flutter configurata
✅ **VPN AL 100% OPERATIVA!**

**Tempo totale**: 5-10 minuti
**Costo**: $0
**Risultato**: VPN production-ready! 🚀
