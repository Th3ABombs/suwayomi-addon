# Suwayomi Server

This add-on runs Suwayomi Server inside Home Assistant.

## Configuration

```yaml
tz: Europe/Rome
```

## Notes

- Persistent data is stored in `/data/Tachidesk`
- Downloads are stored in `/data/Tachidesk/downloads`
- Ingress points directly to port `4567`
- This setup does not add an ingress-specific reverse proxy
