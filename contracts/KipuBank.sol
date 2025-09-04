// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * Nombre: KipuBank
 * Autor: Darío Echeverría Muñoz
 * Objeto: Un banco digital descentralizado que permite a los usuarios depositar y retirar ETH
 * Desarrollo: Contrato que implementa bóvedas personales con límites de seguridad
 */

contract KipuBank {
    // Variables inmutables establecidas en el constructor
    uint256 public immutable WITHDRAWAL_LIMIT;
    
    // Variables de estado del banco
    uint256 public bankCap;
    uint256 public totalDepositado;
    uint256 public totalDepositos;
    uint256 public totalRetiros;
    
    // Mapping para balances personales de usuarios
    mapping(address => uint256) public balances;
    
    // Eventos para operaciones del banco
    event Deposito(address indexed usuario, uint256 cantidad, uint256 nuevoBalance);
    event Retiro(address indexed usuario, uint256 cantidad, uint256 nuevoBalance);
    
    // Errores personalizados
    error CantidadDebeSerMayorACero();
    error BalanceInsuficiente();
    error TransferenciaFallida();
    error ExcedeBankCap(uint256 intentado, uint256 disponible);
    error ExcedeLimiteRetiro(uint256 intentado, uint256 limite);
    
    // Modificador para validar cantidad mayor a cero
    modifier cantidadValida(uint256 _cantidad) {
        if (_cantidad == 0) {
            revert CantidadDebeSerMayorACero();
        }
        _;
    }
    
    // Modificador para validar balance suficiente
    modifier balanceSuficiente(uint256 _cantidad) {
        if (balances[msg.sender] < _cantidad) {
            revert BalanceInsuficiente();
        }
        _;
    }
    
    // Constructor para establecer límites del banco
    constructor(uint256 _bankCap, uint256 _withdrawalLimit) {
        bankCap = _bankCap;
        WITHDRAWAL_LIMIT = _withdrawalLimit;
    }
    
    // Función para depositar ETH (payable externa)
    function deposit() external payable cantidadValida(msg.value) {
        // Validar que no exceda la capacidad del banco
        uint256 espacioDisponible = bankCap - totalDepositado;
        if (msg.value > espacioDisponible) {
            revert ExcedeBankCap(msg.value, espacioDisponible);
        }
        
        // Actualizar balances y contadores
        balances[msg.sender] += msg.value;
        totalDepositado += msg.value;
        totalDepositos++;
        
        // Emitir evento
        emit Deposito(msg.sender, msg.value, balances[msg.sender]);
    }
    
    // Función para retirar ETH
    function withdraw(uint256 cantidad) external 
        cantidadValida(cantidad) 
        balanceSuficiente(cantidad) 
    {
        // Validar límite de retiro
        if (cantidad > WITHDRAWAL_LIMIT) {
            revert ExcedeLimiteRetiro(cantidad, WITHDRAWAL_LIMIT);
        }
        
        // Actualizar balances antes de transferir
        balances[msg.sender] -= cantidad;
        totalDepositado -= cantidad;
        totalRetiros++;
        
        // Transferir ETH usando función privada
        _transferirSeguro(msg.sender, cantidad);
        
        // Emitir evento
        emit Retiro(msg.sender, cantidad, balances[msg.sender]);
    }
    
    // Función privada para transferencias seguras
    function _transferirSeguro(address destino, uint256 cantidad) private {
        (bool success, ) = destino.call{value: cantidad}("");
        if (!success) {
            revert TransferenciaFallida();
        }
    }
    
    // Función view para consultar balance
    function getBalance(address usuario) external view returns (uint256) {
        return balances[usuario];
    }
    
    // Función view para consultar mi balance
    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
    
    // Función view para consultar estadísticas del banco
    function getBankStats() external view returns (
        uint256 _totalDepositado,
        uint256 _totalDepositos,
        uint256 _totalRetiros,
        uint256 _espacioDisponible
    ) {
        return (
            totalDepositado,
            totalDepositos,
            totalRetiros,
            bankCap - totalDepositado
        );
    }
}
