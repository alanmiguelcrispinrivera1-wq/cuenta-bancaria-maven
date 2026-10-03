# Cuenta bancaria — Maven

**Autor:** Alan Miguel Crispin Rivera

Proyecto Java 17 gestionado con Maven. Modela una cuenta bancaria (depósitos, retiros con comisión) e imprime el estado de cuenta en texto y en JSON usando Jackson.

## Cómo construir y correr

    ./mvnw clean package
    java -jar target/cuenta-bancaria-maven-1.0.0.jar

## Qué hay en este proyecto

| Qué | Dónde |
|---|---|
| El programa (estado de cuenta en texto y en JSON) | `src/main/java/com/academia/banco/App.java` |
| Las pruebas | `src/test/java/com/academia/banco/` |
| La evidencia de cada mini-práctica | `evidencia/` |
| Los 5 errores de Maven que encontré | `evidencia/errores-maven.md` |

## Configuración del proyecto (`pom.xml`)

- **Java 17**, definido con `maven.compiler.release`.
- **Versiones centralizadas** en `<properties>`: `jackson.version` (2.22.3) y `junit.version` (5.14.4).
- **Jackson (`jackson-databind`)**: convierte el estado de cuenta a JSON. Está en scope `compile` porque lo usa el código principal.
- **JUnit 5**: solo para pruebas, por eso tiene `<scope>test</scope>` y no está disponible en `src/main/java`.
- **`maven-compiler-plugin` 3.14.0**: fijado para que respete `maven.compiler.release`.
- **`maven-jar-plugin`**: declara `com.academia.banco.App` como clase principal en el manifiesto.
- **`maven-shade-plugin`**: arma un `.jar` "gordo" con tu código y las dependencias, para poder correrlo con `java -jar`.

## Boleto de salida

1. **¿Qué diferencia hay entre `./mvnw package` y `./mvnw install`?**
   `package` compila, prueba y arma el `.jar` en `target/`. `install` hace todo eso y además copia el `.jar` al repositorio local (`~/.m2/repository`), para que otros proyectos de tu máquina puedan usarlo como dependencia.

2. **¿Por qué `compile` pasó pero `java -jar` falló en la MP-3?**
   `compile` solo comprueba que el código compile contra el classpath que arma Maven. `java -jar` usa solo lo que hay dentro del `.jar` y lo que dice su manifiesto, y ahí pueden fallar cosas que `compile` no revisa: una dependencia que no quedó empaquetada (por su scope o por no usar el `.jar` "gordo") o una `mainClass` que no existe. En la queja 5 pasó lo segundo: el build terminó en `BUILD SUCCESS` pero el manifiesto apuntaba a `com.academia.banco.Aplicacion`, una clase inexistente.

3. **En tu proyecto de Spring Boot, ¿de dónde sale la versión de una dependencia que no tiene `<version>`?**
   Del `<parent>` `spring-boot-starter-parent`, que hereda de `spring-boot-dependencies`. Ese POM tiene una sección `<dependencyManagement>` con las versiones compatibles entre sí de cientos de librerías, y Maven las aplica a toda dependencia declarada sin versión.

4. **¿Qué va en `settings.xml` y no en `pom.xml`? ¿Por qué?**
   Va la configuración personal o de tu máquina: credenciales de repositorios (`<servers>`), espejos (`<mirrors>`), proxies y la ubicación del repositorio local. El `pom.xml` se comparte y se sube a Git; las contraseñas y los datos propios de un equipo no deben viajar con el proyecto.