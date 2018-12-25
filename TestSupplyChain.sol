pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

//referenced from https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
contract ThrowProxy {
    address public target;
    bytes data;

    constructor (address _target) public {
        target = _target;
    }

    function() external {
        data = msg.data;
    }

    function execute() public returns (bool) {
        return target.call(data);
    }
}

contract TestSupplyChain {


    uint public initialBalance = 10 ether;

    function testItemNotForSale() public {
        SupplyChain supplyChainContract = new SupplyChain();
        ThrowProxy throwProxy = new ThrowProxy(address(supplyChainContract));
        SupplyChain(address(throwProxy)).addItem("test1", 15 ether);
        bool r1 = throwProxy.execute.gas(200000)();
        Assert.isTrue(r1, "Transaction adding items should not throw errors");
        SupplyChain(address(throwProxy)).buyItem(6433);
        bool r2 = throwProxy.execute.gas(200000)();
        Assert.isFalse(r2, "forSale modifier should be thrown");
    }

    function testShipItemNotSold() public {
        SupplyChain supplyChainContract = new SupplyChain();
        ThrowProxy throwProxy = new ThrowProxy(address(supplyChainContract));
        SupplyChain(address(throwProxy)).addItem("test1", 15 ether);
        bool r1 = throwProxy.execute.gas(200000)();
        Assert.isTrue(r1, "Transaction adding items should not throw errors");
        SupplyChain(address(throwProxy)).shipItem(0);
        bool r2 = throwProxy.execute.gas(200000)();
        Assert.isFalse(r2, "sold modifier should be thrown");
    }

    function testReceivedItemNotShipped() public {
        SupplyChain supplyChainContract = new SupplyChain();
        ThrowProxy throwProxy = new ThrowProxy(address(supplyChainContract));
        SupplyChain(address(throwProxy)).addItem("test1", 15 ether);
        bool r1 = throwProxy.execute.gas(200000)();
        Assert.isTrue(r1, "Transaction adding items should not throw errors");
        SupplyChain(address(throwProxy)).receiveItem(0);
        bool r2 = throwProxy.execute.gas(200000)();
        Assert.isFalse(r2, "shipped modifier should be thrown");
    }
     


}

/*

// NOTES: 
// https://michalzalecki.com/ethereum-test-driven-introduction-to-solidity/
// https://github.com/dappuniversity/token_sale
// https://www.sitepoint.com/truffle-testing-smart-contracts/
// https://github.com/trufflesuite/truffle/tree/master/packages/truffle-core/lib/testing
//
//  enum State {ForSale, Sold, Shipped, Received} 
//  ForSale 0, Sold 1, Shipped 2, Received 3
// https://books.google.co.uk/books?id=Z3JiDwAAQBAJ&pg=PA116&lpg=PA116&dq=DeployedAddresses.sol&source=bl&ots=klqwssBnmS&sig=yYwxkJ9fW-m2A5yO2ZM17H3RKRE&hl=en&sa=X&ved=2ahUKEwinw76K6bbfAhXQGuwKHZ_qAl44ChDoATAEegQIBRAB#v=onepage&q=DeployedAddresses.sol&f=false
//
// /ac
 
contract TestSupplyChain {
   
    uint public initialBalance = 1 ether;
    SupplyChain supplychain = SupplyChain(DeployedAddresses.SupplyChain());
    //address public owner = this;
    address public seller = address(1);
    address public buyer = address(2);
    //uint public bal = address(supplychain).balance;
    //function beforeAll() public {
    //}
  
    //function beforeEach() public {
    //}
    
    function testAddItem() public {
      Assert.equal(supplychain.skuCount(), 0, "Initial SKU count is not zero");
      bool result = supplychain.addItem('Test Item', 2000);
      Assert.isTrue(result, "addItem('Test Item', price); did not return success");
      Assert.equal(supplychain.skuCount(), 1, "Item not added, skuCount is not 1");


      supplychain.addItem('Test Item2', 4000);
      //address sc = supplychain.owner();
      //Assert.equal(sc, owner, "Owner is not supplychain");

      // TODO test: emit ForSale(skuCount);
    }

    function testBuyItem() public payable {
      // TODO test: forSale(sku)
      // TODO test: paidEnough(items[sku].price)
      // TODO test: checkValue(sku)
      string memory name;
      uint sku = 0;
      uint price = 2;
      uint state;
//      address seller;
//      address buyer;

      (name, sku, price, state, seller, buyer) = supplychain.fetchItem(sku);
      Assert.equal(state, 0, 'Sate ');

      address(supplychain).call.value(200000)(abi.encodeWithSignature("buyItem(uint)", sku)); 
      //address(supplychain).call.value(2000)(abi.encodeWithSignature("buyItem(uint)", sku)); 
      //address(1).call.value(2000)(abi.encodeWithSignature("buyItem(uint)", sku)); 
      //bool result = address(supplychain).call.value(200)(abi.encodeWithSignature("buyItem(uint)", sku)); 
      //supplychain.buyItem.value(2)(0);
      (name, sku, price, state, seller, buyer) = supplychain.fetchItem(sku);
      Assert.equal(name, 'Test Item', 'Item called *Test Item* not purchased');
      Assert.equal(state, 0, 'Sate ');
      //Assert.equal(seller, msg.sender, 'Seller is not msg.sender');
      //Assert.equal(buyer, address(1), 'Buyer is not msg.sender');
    }
}
*/ 

/*
    // Test for failing conditions in this contracts
    // test that every modifier is working

    // addItem

    // buyItem

    // test for failure if user does not send enough funds
    // test for purchasing an item that is not for Sale


    // shipItem

    // test for calls that are made by not the seller
    // test for trying to ship an item that is not marked Sold

    // receiveItem

    // test calling the function from an address that is not the buyer
    // test calling the function on an item not marked Shipped


https://github.com/trufflesuite/truffle/blob/develop/packages/truffle-core/lib/testing/Assert.sol
*/
