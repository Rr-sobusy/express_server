//Import sequelize module
const { Sequelize, Model } = require("sequelize");

//Configuratin
const sequelize = new Sequelize("nfic_db", "postgres", "3J^3Pm^Mp5", {
  host: "localhost",
  dialect: "postgres",
  dialectOptions: {
    useUTC: false,
  },
  timezone: "+08:00",
});

module.exports = sequelize;
