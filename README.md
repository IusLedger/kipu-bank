# KipuBank - Banco Digital Descentralizado

## Descripción del Proyecto

KipuBank es un contrato inteligente que simula un banco digital donde los usuarios pueden depositar y retirar ETH de manera segura. Cada usuario tiene su propia "alcancía" personal dentro del banco, con límites de seguridad para proteger tanto a los usuarios como al sistema.

## Funcionalidades Principales

- **Depósitos personales**: Cada usuario puede depositar ETH en su cuenta personal
- **Retiros controlados**: Los usuarios pueden retirar sus fondos respetando límites de seguridad
- **Límites del sistema**: El banco tiene una capacidad máxima y límites de retiro por transacción
- **Estadísticas**: El contrato lleva registro de todas las operaciones
- **Seguridad**: Implementa patrones de seguridad estándar de la industria

## Estructura del Contrato

### Variables de Estado
- `WITHDRAWAL_LIMIT`: Límite máximo de retiro por transacción (inmutable)
- `bankCap`: Capacidad total máxima del banco
- `totalDepositado`: Total de ETH almacenado en el contrato
- `totalDepositos`: Contador de depósitos realizados
- `totalRetiros`: Contador de retiros realizados
- `balances`: Mapping que guarda el balance de cada usuario

### Eventos
- `Deposito`: Se emite cuando un usuario deposita ETH
- `Retiro`: Se emite cuando un usuario retira ETH

### Errores Personalizados
- `CantidadDebeSerMayorACero()`: Para operaciones con valor cero
- `BalanceInsuficiente()`: Cuando el usuario no tiene fondos suficientes
- `TransferenciaFallida()`: Cuando falla el envío de ETH
- `ExcedeBankCap()`: Cuando se supera la capacidad del banco
- `ExcedeLimiteRetiro()`: Cuando se supera el límite de retiro

## Instrucciones de Despliegue

### Preparación
1. Abrir Remix IDE (https://remix.ethereum.org)
2. Crear una nueva carpeta llamada `contracts`
3. Dentro de `contracts`, crear el archivo `KipuBank.sol`
4. Copiar y pegar el código del contrato

### Configuración de Remix
1. Ir a la pestaña "Solidity Compiler"
2. Seleccionar la versión ^0.8.30
3. Compilar el contrato

### Configuración de MetaMask
1. Asegurar que MetaMask esté instalado y configurado
2. Cambiar a la red de prueba Sepolia
3. Obtener ETH de prueba desde un faucet de Sepolia

### Despliegue
1. Ir a la pestaña "Deploy & Run Transactions"
2. Seleccionar "Injected Provider - MetaMask" como environment
3. Confirmar que la cuenta y red son correctas
4. En el constructor, ingresar los parámetros:
   - `_bankCap`: Ejemplo: `10000000000000000000` (10 ETH en wei)
   - `_withdrawalLimit`: Ejemplo: `1000000000000000000` (1 ETH en wei)
5. Hacer clic en "Deploy"
6. Confirmar la transacción en MetaMask

## Cómo Interactuar con el Contrato

### Depositar ETH
1. En la función `deposit`, no ingresar parámetros
2. En el campo "Value", ingresar la cantidad a depositar (ejemplo: 0.1 ETH)
3. Hacer clic en "deposit"
4. Confirmar la transacción en MetaMask

### Retirar ETH
1. En la función `withdraw`, ingresar la cantidad en wei
   - Ejemplo: para retirar 0.05 ETH, ingresar `50000000000000000`
2. Hacer clic en "withdraw"
3. Confirmar la transacción en MetaMask

### Consultar Información
- `getMyBalance()`: Ver tu balance actual
- `getBalance()`: Ver el balance de cualquier dirección
- `getBankStats()`: Ver estadísticas completas del banco

## Casos de Prueba

### Pruebas Exitosas
1. Depositar 0.1 ETH → El balance debe aumentar correctamente
2. Retirar 0.05 ETH → El balance debe disminuir y recibir el ETH
3. Consultar balance → Debe mostrar el monto correcto

### Pruebas de Error
1. Intentar depositar 0 ETH → Debe fallar con `CantidadDebeSerMayorACero`
2. Intentar retirar más del balance → Debe fallar con `BalanceInsuficiente`
3. Intentar retirar más del límite → Debe fallar con `ExcedeLimiteRetiro`
4. Intentar depositar más de la capacidad del banco → Debe fallar con `ExcedeBankCap`

## Características de Seguridad Implementadas

1. **Patrón Checks-Effects-Interactions**: Las validaciones se hacen antes de cambiar el estado
2. **Transferencias seguras**: Uso de `call()` en lugar de `transfer()`
3. **Modificadores**: Reutilización de validaciones para evitar código duplicado
4. **Errores personalizados**: Información clara sobre qué falló
5. **Variables inmutables**: El límite de retiro no puede cambiarse después del despliegue

## Información del Contrato Desplegado

**Red de Despliegue**: Sepolia Testnet
**Dirección del Contrato**: [Completar después del despliegue]
**Enlace del Explorador**: [Completar después del despliegue]

### Parámetros Utilizados en el Despliegue
- Bank Cap: [Completar con el valor usado]
- Withdrawal Limit: [Completar con el valor usado]

## Tecnologías y Herramientas

- **Solidity**: Versión ^0.8.30
- **Remix IDE**: Para desarrollo y despliegue
- **MetaMask**: Para interacción con la blockchain
- **Sepolia Testnet**: Red de prueba de Ethereum

## Próximos Desarrollos

Este contrato base puede expandirse con:
- Integración con tokens ERC-20
- Sistema de intereses por depósitos
- Múltiples tipos de cuentas
- Interfaz web para facilitar su uso

---

**Nota**: Este proyecto fue desarrollado como parte del aprendizaje en desarrollo Web3 y smart contracts con Solidity.
