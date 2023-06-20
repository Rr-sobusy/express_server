//Import db config built by sequelize library
const sequelize = require('../configs/db.config')
const {DataTypes} = require('sequelize')

//Define model for packaging

const Packaging = sequelize.define('packagings',{
    packaging_id :{
        type : DataTypes.NUMBER,
        primaryKey : true
    },
    packaging_name : {
        type : DataTypes.CHAR
    },
    initial_stocks : {
        type : DataTypes.NUMBER
    },
},{
    timestamps : false
})

const ReleasedPackagings = sequelize.define('released_packagings',{
        id : {
            primaryKey : true,
            type : DataTypes.NUMBER
        },
        packaging_id : {
            type : DataTypes.NUMBER
        }

},{
    timestamps : false
})





//Export the defined model/s
module.exports =  {
    Packaging,
    ReleasedPackagings
}