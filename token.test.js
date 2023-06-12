// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token", function () {

    let token;
    let rocco = "0x79177fD38B4763278Dcd0A7E42Ef47601160eb83";
    let signers;

    beforeEach(async function (){
        // signers is an array of addresses, populated with test ether
        signers = await ethers.getSigners();
        const Token = await ethers.getContractFactory("Token");
        token = await Token.deploy();
        await token.deployed();
    });

    it("test initial value", async function () {
        console.log('token deployed at:'+ token.address);
        expect((await token.balanceOf(rocco)).toNumber()).to.equal(0);
    });

    it("test mint", async function () {
        console.log('token deployed at:'+ token.address);
        const tx = await token.connect(signers[1]).mint(signers[1].address);
        await tx.wait();
        expect((await token.balanceOf(signers[1].address)).toNumber()).to.equal(10);
    });

    it("test transfer leaves transfer sender with correct balance", async function () {
        console.log('token deployed at:'+ token.address);
        const tx = await token.connect(signers[1]).mint(signers[2].address);
        await tx.wait();
        const transferred = await token.connect(signers[2]).transfer(signers[3].address, 5);
        await transferred.wait();
        expect((await token.balanceOf(signers[3].address)).toNumber()).to.equal(5);
    });

    it("test transferfrom", async function () {
        console.log('token deployed at:'+ token.address);
        const tx = await token.connect(signers[1]).mint(signers[2].address);
        await tx.wait();
        const approval = await token.connect(signers[2]).approve(signers[1].address, 5);
        await approval.wait();
        const transferredFrom = await token.connect(signers[1]).transferFrom(signers[2].address, signers[3].address, 5);
        await transferredFrom.wait();
        expect((await token.balanceOf(signers[2].address)).toNumber()).to.equal(5);
        expect((await token.balanceOf(signers[3].address)).toNumber()).to.equal(5);

    });

});
