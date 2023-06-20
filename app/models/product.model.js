//Import db config built by sequelize library
const sequelize = require('../configs/db.config')
const {DataTypes} = require('sequelize')

//Define the models for products

const Products = sequelize.define('products',{
        product_id : {
            type : DataTypes.NUMBER,
            primaryKey : true,
            autoIncrement : true
        },
        product_name : {
            type : DataTypes.CHAR
        },
        initial_stocks : {
            type : DataTypes.NUMBER
        },
        packaging_size : DataTypes.NUMBER
},{
    timestamps : false
})


module.exports = {
    Products
}