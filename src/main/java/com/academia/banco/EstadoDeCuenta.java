package com.academia.banco;

import java.math.BigDecimal;
import java.util.List;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/** El estado de cuenta en JSON, como lo mandaría una API. Usa Jackson, una librería que NO es de Java. */
public record EstadoDeCuenta(String titular, BigDecimal saldo, List<Movimiento> movimientos) {

    public static EstadoDeCuenta de(CuentaBancaria cuenta) {
        return new EstadoDeCuenta(cuenta.getTitular(), cuenta.getSaldo(), cuenta.getMovimientos());
    }

    public String comoJson() throws JsonProcessingException {
        return new ObjectMapper().writerWithDefaultPrettyPrinter().writeValueAsString(this);
    }
}