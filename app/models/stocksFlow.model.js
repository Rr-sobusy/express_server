//Import db config built by sequelize library
const sequelize = require("../configs/db.config");
const { DataTypes } = require("sequelize");

//Define the models

const StocksChange = sequelize.define('stocks_flow', {
    id : {
        type : DataTypes.NUMBER,
        primaryKey : true
    },
    product_id : {
        type : DataTypes.NUMBER
    },
    update_type : {
        type : DataTypes.CHAR
    },
    quantity : {
        type : DataTypes.NUMBER
    },
    new_quantity : {
        type : DataTypes.NUMBER
    },
    update_key : {
        type : DataTypes.CHAR
    },
},{
    timestamps : false
})



//Export modules
module.exports = {
    StocksChange
}