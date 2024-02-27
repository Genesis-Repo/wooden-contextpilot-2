// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract DefiAggregator is ReentrancyGuard {
    mapping(string => address) private defiPools;

    event DefiPoolAdded(string indexed poolName, address indexed poolAddress);
    event TokensSentToDefiPool(string indexed poolName, address indexed token, uint256 amount, address indexed sender);

    function addDefiPool(string calldata _poolName, address _poolAddress) external {
        require(defiPools[_poolName] == address(0), "Pool already exists");
        defiPools[_poolName] = _poolAddress;
        emit DefiPoolAdded(_poolName, _poolAddress);
    }

    function sendToDefiPool(string calldata _poolName, address _token, uint256 _amount) external nonReentrant {
        address poolAddress = defiPools[_poolName];
        require(poolAddress != address(0), "Pool does not exist");

        IERC20 token = IERC20(_token);
        require(token.transferFrom(msg.sender, poolAddress, _amount), "Token transfer failed");
        emit TokensSentToDefiPool(_poolName, _token, _amount, msg.sender);
    }
}