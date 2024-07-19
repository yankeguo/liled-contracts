// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AccessControlDefaultAdminRules} from "@openzeppelin/contracts/access/extensions/AccessControlDefaultAdminRules.sol";

contract LiLED is AccessControlDefaultAdminRules {
    bytes32 public constant PRICESETUP_ROLE = keccak256("PRICESETUP_ROLE");
    bytes32 public constant WITHDRAWAL_ROLE = keccak256("WITHDRAWAL_ROLE");

    uint256 private _price;

    constructor() AccessControlDefaultAdminRules(3 days, msg.sender) {
        // set initial price to 50 IOTX
        _setPrice(50 * 10 ** 18);
        // grant the deployer the withdrawal role and the price setup role
        _grantRole(PRICESETUP_ROLE, msg.sender);
        _grantRole(WITHDRAWAL_ROLE, msg.sender);
    }

    function _getPrice() internal view returns (uint256) {
        return _price;
    }

    function _setPrice(uint256 price) internal {
        _price = price;
    }

    function getPrice() external view returns (uint256) {
        return _getPrice();
    }

    function setPrice(uint256 price) external onlyRole(PRICESETUP_ROLE) {
        _setPrice(price);
    }

    event Purchased(address, uint256, string);

    // purchase function is called to purchase and display the content
    function purchase(string memory content) external payable {
        require(msg.value >= _getPrice(), "LiLED: insufficient fund");
        emit Purchased(msg.sender, msg.value, content);
    }

    event Received(address, uint256);

    // receive function is called when the contract receives ether
    // considered as donation since it does not have any logic
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // withdraw function is called to withdraw the ether from the contract
    function withdraw(uint256 amount) external onlyRole(WITHDRAWAL_ROLE) {
        payable(msg.sender).transfer(amount);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(AccessControlDefaultAdminRules)
        returns (bool)
    {
        return AccessControlDefaultAdminRules.supportsInterface(interfaceId);
    }
}
