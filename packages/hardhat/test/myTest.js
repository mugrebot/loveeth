const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

describe("YourCollectible", function () {
  let myContract;

  // quick fix to let gas reporter fetch data from gas station & coinmarketcap
  before((done) => {
    setTimeout(done, 2000);
  });

  describe("YourCollectible", function () {
    it("Should deploy YourContract", async function () {
      const YourContract = await ethers.getContractFactory("YourCollectible");
      

      myContract = await YourContract.deploy();
    });

    describe("_safeMint()", function () {
      it("Should be able to set a new purpose", async function () {
        
        const sender = this.addr1;
        const quantity = 5;

        await myContract.mintItem(quantity);
        expect(await myContract.totalSupply()).to.equal(quantity);
      });

      

      // Uncomment the event and emit lines in YourContract.sol to make this test pass

      /*it("Should emit a SetPurpose event ", async function () {
        const [owner] = await ethers.getSigners();
        const newPurpose = "Another Test Purpose";
        expect(await myContract.setPurpose(newPurpose)).to.
          emit(myContract, "SetPurpose").
            withArgs(owner.address, newPurpose);
      });*/
    });

    describe('exists', async function () {
      it('verifies valid tokens', async function () {
        for (let id = 0; id < 6; id++) {
          const exists = await this.myContract.id;
          expect(exists).to.be.true;
        }
      });
  });
});