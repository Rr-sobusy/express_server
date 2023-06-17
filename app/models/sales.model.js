//Import db config built by sequelize library
const sequelize = require('../configs/db.config')
const {DataTypes} = require('sequelize')

//Define the models for sales model in product sales table

//Sales instance
const Sales = sequelize.define('product_sales', {
    sales_id : {
        type: DataTypes.NUMBER,
        primaryKey : true
    },
    customer_name : {
        type : DataTypes.CHAR
    },
    sales_date : {
        type : DataTypes.CHAR
    }
},{
    timestamps : false
})






//Sales items
const SalesItems = sequelize.define('sales_items' , {
    id : {
        primaryKey : true,
        type : DataTypes.NUMBER
    },
    sales_id : {
        type : DataTypes.NUMBER
    },
    product_id : {
        type : DataTypes.NUMBER
    },
    quantity : {
        type : DataTypes.NUMBER
    }

},{
    timestamps : false
})



//Export the defined models
module.exports = {
  Sales,
  SalesItems
}