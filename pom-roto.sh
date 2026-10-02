#!/usr/bin/env bash
# MP-5 · Cazar errores. Rompe tu pom.xml a propósito, como lo dejaría un compañero con prisa.
#   ./pom-roto.sh 1         guarda tu pom bueno en .pom-bueno.xml (solo la primera vez) y te deja la queja 1
#   ./pom-roto.sh revisar   compara tu pom.xml con el bueno: dice si ya quedó igual (y si no, cerca de qué línea)
# Las quejas van codificadas a propósito: la gracia es encontrar el error leyendo lo que dice Maven.
set -u
bueno=.pom-bueno.xml
nucleo() { python3 -c "$(echo 'IyBOw7pjbGVvIGRlIHBvbS1yb3RvLnNoIChzZSBpbmNydXN0YSBlbiBiYXNlNjQgcGFyYSBxdWUgZWwgYWx1bW5vIG5vIHZlYSBsYXMgcmVzcHVlc3RhcyBhbCBwZWdhciBjcmVhci1wcm95ZWN0by5zaCkuCiMgVXNvOiBweXRob24zIHF1ZWphcy5weSByb21wZXIgTiB8IHJldmlzYXIgICAgICh0cmFiYWphIHNvYnJlIHBvbS54bWwgeSAucG9tLWJ1ZW5vLnhtbCBlbiBsYSBjYXJwZXRhIGFjdHVhbCkKaW1wb3J0IHJlLCBzeXMsIGRpZmZsaWIKQlVFTk8gPSAnLnBvbS1idWVuby54bWwnCmRlZiBsZWVyKHApOiByZXR1cm4gb3BlbihwLCBlbmNvZGluZz0ndXRmLTgnKS5yZWFkKCkucmVwbGFjZSgnXHJcbicsICdcbicpCmRlZiBub3JtKHMpOgogICAgcyA9IHJlLnN1YihyJzwhLS0uKj8tLT4nLCAnJywgcywgZmxhZ3M9cmUuUykKICAgICMgRW4gSmFja3NvbiwgPHNjb3BlPmNvbXBpbGU8L3Njb3BlPiA9IG5vIHBvbmVyIHNjb3BlOiB0YW1iacOpbiBlcyB1biBhcnJlZ2xvIHbDoWxpZG8gZGUgbGEgcXVlamEgNAogICAgcyA9IHJlLnN1YihyJyg8dmVyc2lvbj5cJFx7amFja3NvblwudmVyc2lvblx9PC92ZXJzaW9uPilccyo8c2NvcGU+XHMqY29tcGlsZVxzKjwvc2NvcGU+JywgcidcMScsIHMpCiAgICAjIFNlIGNvbGFwc2FuIGxvcyBlc3BhY2lvcyAobm8gc2UgYm9ycmFuOiDCqzIuMjIuIDPCuyBOTyBlcyDCqzIuMjIuM8K7KSB5IHNlIHF1aXRhbiBzb2xvIGxvcyBxdWUgcm9kZWFuIGV0aXF1ZXRhcy4KICAgIHMgPSByZS5zdWIocidccysnLCAnICcsIHMpCiAgICByZXR1cm4gcmUuc3ViKHInID8oPFtePl0qPikgPycsIHInXDEnLCBzKS5zdHJpcCgpClJPTVBFUiA9IHsKICAgICcxJzogKHInKDx2ZXJzaW9uPlwkXHtqYWNrc29uXC52ZXJzaW9uXH08L3ZlcnNpb24+XHMqKTwvZGVwZW5kZW5jeT4nLCByJ1wxPC9kZXBlbmRlbmNpYT4nKSwKICAgICcyJzogKHInPG1hdmVuXC5jb21waWxlclwucmVsZWFzZT5ccyoxN1xzKjwvbWF2ZW5cLmNvbXBpbGVyXC5yZWxlYXNlPicsICc8bWF2ZW4uY29tcGlsZXIucmVsZWFzZT4yMTwvbWF2ZW4uY29tcGlsZXIucmVsZWFzZT4nKSwKICAgICczJzogKHInPGphY2tzb25cLnZlcnNpb24+XHMqMlwuMjJcLjNccyo8L2phY2tzb25cLnZlcnNpb24+JywgJzxqYWNrc29uLnZlcnNpb24+Mi4yMi4zMDwvamFja3Nvbi52ZXJzaW9uPicpLAogICAgJzQnOiAocicoXG4oWyBcdF0qKTx2ZXJzaW9uPlwkXHtqYWNrc29uXC52ZXJzaW9uXH08L3ZlcnNpb24+KScsIHInXDFcblwyPHNjb3BlPnRlc3Q8L3Njb3BlPicpLAogICAgJzUnOiAocic8bWFpbkNsYXNzPlxzKmNvbVwuYWNhZGVtaWFcLmJhbmNvXC5BcHBccyo8L21haW5DbGFzcz4nLCAnPG1haW5DbGFzcz5jb20uYWNhZGVtaWEuYmFuY28uQXBsaWNhY2lvbjwvbWFpbkNsYXNzPicpLAp9CmlmIHN5cy5hcmd2WzFdID09ICdyb21wZXInOgogICAgcGF0cm9uLCByZWVtcGxhem8gPSBST01QRVJbc3lzLmFyZ3ZbMl1dCiAgICBzLCBuID0gcmUuc3VibihwYXRyb24sIHJlZW1wbGF6bywgbGVlcihCVUVOTyksIGNvdW50PTEpCiAgICBpZiBuICE9IDE6IHN5cy5leGl0KDMpCiAgICBvcGVuKCdwb20ueG1sJywgJ3cnLCBlbmNvZGluZz0ndXRmLTgnKS53cml0ZShzKQplbHNlOgogICAgYnVlbm8sIHR1eW8gPSBsZWVyKEJVRU5PKSwgbGVlcigncG9tLnhtbCcpCiAgICBpZiBub3JtKGJ1ZW5vKSA9PSBub3JtKHR1eW8pOiBwcmludCgn4pyFIFR1IHBvbS54bWwgcXVlZMOzIGlndWFsIGFsIGJ1ZW5vLicpOyBzeXMuZXhpdCgwKQogICAgYiA9IFtsLnN0cmlwKCkgZm9yIGwgaW4gYnVlbm8uc3BsaXQoJ1xuJyldOyB0ID0gW2wuc3RyaXAoKSBmb3IgbCBpbiB0dXlvLnNwbGl0KCdcbicpXQogICAgbGluZWFzID0gc29ydGVkKHtqMSArIDEgZm9yIG9wLCBpMSwgaTIsIGoxLCBqMiBpbiBkaWZmbGliLlNlcXVlbmNlTWF0Y2hlcihOb25lLCBiLCB0LCBhdXRvanVuaz1GYWxzZSkuZ2V0X29wY29kZXMoKQogICAgICAgICAgICAgICAgICAgICBpZiBvcCAhPSAnZXF1YWwnIGFuZCBhbnkoeCBmb3IgeCBpbiBiW2kxOmkyXSArIHRbajE6ajJdKX0pCiAgICBkb25kZSA9ICcgeSAnLmpvaW4oc3RyKG1pbihsLCBsZW4odCkpKSBmb3IgbCBpbiBsaW5lYXNbOjNdKSBvciAnPycKICAgIHByaW50KGYn4pyXIFRvZGF2w61hIG5vOiB0dSBwb20ueG1sIGVzIGRpc3RpbnRvIGRlbCBidWVubyBjZXJjYSBkZSBsYSBsw61uZWEge2RvbmRlfS4gVnVlbHZlIGEgbGVlciBsbyBxdWUgZGlqbyBNYXZlbi4nKQogICAgc3lzLmV4aXQoMSkK' | base64 -d)" "$@"; }
if [ "${1:-}" = "revisar" ]; then
  if [ ! -f "$bueno" ]; then echo "Todavía no rompes nada: corre ./pom-roto.sh 1"; exit 2; fi
  nucleo revisar; exit $?
fi
case "${1:-}" in 1|2|3|4|5) ;; *) echo "Uso: ./pom-roto.sh <1 a 5>   o   ./pom-roto.sh revisar"; exit 2 ;; esac
nuevo=0
if [ ! -f "$bueno" ]; then
  if ! grep -q '<jackson.version>2.22.3</jackson.version>' pom.xml || ! grep -q '<version>${jackson.version}</version>' pom.xml \
     || [ "$(grep -c '<artifactId>jackson-databind</artifactId>' pom.xml)" != 1 ] \
     || ! grep -q '<mainClass>com.academia.banco.App</mainClass>' pom.xml; then
    echo "Tu pom.xml no está como lo dejó la MP-4: compáralo con el «así debe quedar» de la MP-4 y vuelve a intentar."; exit 2
  fi
  cp pom.xml "$bueno"; nuevo=1
fi
if ! nucleo romper "$1" || cmp -s "$bueno" pom.xml; then
  # romper no escribió pom.xml (o lo dejó igual): el pom del alumno no se toca
  [ "$nuevo" = 1 ] && rm -f "$bueno"
  echo "No pude preparar la queja $1 con tu pom.xml (tu pom.xml sigue igual). Avísale al instructor."; exit 3
fi
echo "Queja $1: tu pom.xml tiene un error. Encuéntralo con lo que dice Maven (la guía te dice qué correr)."
