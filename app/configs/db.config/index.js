//Import sequelize module
const {Sequelize, Model} = require('sequelize')

//Configuratin
const sequelize = new Sequelize('nfic_db','postgres','3J^3Pm^Mp5',{
    host : 'localhost',
    dialect : 'postgres'
})

module.exports = sequelize

