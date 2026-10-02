#!/usr/bin/env bash
# Corre ./mvnw con las fases o goals que le pidas y guarda la salida COMPLETA en evidencia/<nombre>.txt.
# En pantalla deja solo un RESUMEN: qué plugin corrió en cada paso, las descargas, las pruebas, el árbol de
# dependencias, los errores y el resultado. Lo que no sale en pantalla sigue en el archivo: ábrelo si lo necesitas.
# Uso: ./evidencia.sh <nombre> <fases o goals…>      ejemplo: ./evidencia.sh mp2-test test
if [ $# -lt 2 ]; then
  echo "Uso: ./evidencia.sh <nombre> <fases o goals de Maven…>   (ejemplo: ./evidencia.sh mp2-test test)"; exit 2
fi
nombre="$1"; shift
case "$nombre" in
  ""|*[!A-Za-z0-9_-]*) echo "Nombre inválido: «${nombre}». Usa solo letras, números, - y _ (ejemplo: mp2-test)"; exit 2 ;;
esac
archivo="evidencia/$nombre.txt"
mkdir -p evidencia
echo "\$ ./mvnw -B $*" > "$archivo"
./mvnw -B "$@" >> "$archivo" 2>&1
codigo=$?
echo "\$ ./mvnw $*"
awk -v dir="$PWD/" '
  function clave(l) { sub(/^\[(ERROR|FATAL)\] */, "", l); sub(/^ +/, "", l); sub(/ -> \[Help [0-9]+\]$/, "", l); return l }
  arbol && /^\[INFO\] -----/        { arbol = 0 }
  arbol && /^\[INFO\] [a-z+|\\ ]/   { print "    " substr($0, 8); next }
  /^\[INFO\] --- /                  { l = substr($0, 12); sub(/ @ .*/, "", l); print "  paso: " l
                                      if (l ~ /^dependency:[^:]*:tree/) arbol = 1; next }
  /^\[INFO\] Downloaded from /       { descargas++; next }
  /^\[INFO\] Tests are skipped/       { print "  (pruebas saltadas: Tests are skipped)"; next }
  /Tests run:.*Fail/ && !/ -- in / { print "  " substr($0, index($0, "Tests run:")); next }
  /^\[WARNING\]/                   { avisos++; next }
  /^\[(ERROR|FATAL)\] *$/          { next }
  /^\[ERROR\] (-> \[Help [0-9]+\]|To see the full stack trace|Re-run Maven using|For more information about the errors|\[Help [0-9]+\] http)/ { ayuda++; next }
  /^\[(ERROR|FATAL)\]/ || /^  (symbol|location): / {
                                     l = $0; gsub(dir, "", l); k = clave(l)
                                     if (despues && (k in visto)) { repetidas++; next }
                                     visto[k] = 1; print "  " l; errores++
                                     if (l ~ /Failed to execute goal|The build could not read/) despues = 1
                                     next }
  /BUILD (SUCCESS|FAILURE)/        { resultado = substr($0, index($0, "BUILD")) }
  END {
    if (descargas) print "  (descargó " descargas " archivos de Maven Central)"
    if (avisos) print "  (" avisos (avisos == 1 ? " línea" : " líneas") " [WARNING]: avisos, no errores; están en el archivo)"
    if (repetidas || ayuda) { m = repetidas + ayuda; print "  (no se muestran " m (m == 1 ? " línea" : " líneas") " [ERROR]: repeticiones o ayuda general de Maven; están en el archivo)" }
    if (resultado) print resultado
    else if (errores) print "Maven se detuvo antes de empezar: no dice BUILD SUCCESS ni BUILD FAILURE"
  }
' "$archivo"
if ! grep -qE 'BUILD (SUCCESS|FAILURE)|^\[(ERROR|FATAL)\]' "$archivo"; then
  echo "--- Maven no dijo BUILD SUCCESS ni BUILD FAILURE, ni dio un error. Las últimas 15 líneas: ---"
  tail -15 "$archivo"
fi
echo "→ salida completa en $archivo ($(wc -l < "$archivo") líneas)"
exit "$codigo"
