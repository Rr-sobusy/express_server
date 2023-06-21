//Import sequelize module
const { Sequelize, Model } = require("sequelize");

//Configuratin
const sequelize = new Sequelize("umpvqucx", "umpvqucx", "96vkhTklkMpTk4xP4UtDcho-WjlUyptA", {
  host: "	tiny.db.elephantsql.com",
  dialect: "postgres",
  dialectOptions: {
    useUTC: false,
  },
  timezone: "+08:00",
});

module.exports = sequelize;
