const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Locktoken", function () {
  it("Should set the right owner", async function () {

    const [owner, addr1, addr2] = await ethers.getSigners();

    const ECIOToken = await ethers.getContractFactory("ECIOToken");
    const ecioToken = await ECIOToken.deploy();
    await ecioToken.deployed();

    const ECIOLockToken = await ethers.getContractFactory("ECIOLockToken");
    const ecioLockToken = await ECIOLockToken.deploy(ecioToken.address);
    await ecioLockToken.deployed();

    expect(await ecioToken.owner()).to.equal(owner.address);
    expect(await ecioLockToken.owner()).to.equal(owner.address);
  });

  it("Sould transfer token to ECIOLockToken contract", async function () {

    const [owner, addr1, addr2] = await ethers.getSigners();

    const ECIOToken = await ethers.getContractFactory("ECIOToken");
    const ecioToken = await ECIOToken.deploy();
    await ecioToken.deployed();

    const ECIOLockToken = await ethers.getContractFactory("ECIOLockToken");
    const ecioLockToken = await ECIOLockToken.deploy(ecioToken.address);
    await ecioLockToken.deployed();

    await ecioToken.transfer(ecioLockToken.address, '1000000000000000000000000');

    expect(await ecioToken.balanceOf(ecioLockToken.address)).to.equal('1000000000000000000000000');

  });

  it("Sould _transferToOwner and wrong owner", async function () {

    const [owner, addr1, addr2] = await ethers.getSigners();

    const ECIOToken = await ethers.getContractFactory("ECIOToken");
    const ecioToken = await ECIOToken.deploy();
    await ecioToken.deployed();

    const ECIOLockToken = await ethers.getContractFactory("ECIOLockToken");
    const ecioLockToken = await ECIOLockToken.deploy(ecioToken.address);
    await ecioLockToken.deployed();

    await ecioToken.transfer(ecioLockToken.address, '1000000000000000000000000');

    await ecioLockToken.setAmountPerPeriod('1', '1000000000000000000000000');
    await ecioLockToken.setPeriodReleaseTime('1', '1639951200');
    await ecioLockToken.connect(addr1)._transferToOwner(addr1.address, '1000000000000000000000000', '1');


    expect(await ecioToken.balanceOf(addr1.address)).to.equal('1000000000000000000000000');
  });



});
