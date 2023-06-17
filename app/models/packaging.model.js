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
    // current_stocks : {
    //     type : DataTypes.VIRTUAL,
    //     get(){
    //         const set = sequelize.query(`Select Sum(quantity_released) from released_packagings`)
    //         return set.sum
    //     }
    // }
},{
    timestamps : false
})

const ReleasedPackagings = sequelize.define('released_packagings',{
        id : {
            primaryKey : true,
            type : DataTypes.NUMBER
        },

},{
    timestamps : false
})





//Export the defined model/s
module.exports =  {
    packaging : Packaging,
    releasedPackaging : ReleasedPackagings
}