var HitList = artifacts.require("./HitList.sol");
var Migrations = artifacts.require("./Migrations.sol");
var Random = artifacts.require("./Random.sol");
var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Structs = artifacts.require("./Structs.sol");

module.exports = function (deployer) {
    deployer.deploy(HitList);
    deployer.deploy(Migrations);
    deployer.deploy(Random);
    deployer.deploy(SimpleStorage);
    deployer.deploy(Structs);
};
