// Import Main modules
const express = require("express");
const app = express();

//Parsing bodies, parse URL-encoded and JSON request bodies
app.use(express.urlencoded({ extended: true }));
//Cors
const cors = require("cors");
//Use cors
app.use(cors());

//Import route custom module
const routes = require("./app/routes");
//Load the routes to the server
app.use("/", routes);

//Start the server
const PORT = process.env.PORT || 3003;
app.listen(PORT, () => {
  console.log(`Server running at port:${PORT}`);
});

// const { Sequelize } = require('sequelize');
// const {DataTypes} = require('sequelize')

// const sequelize = new Sequelize('sample_database', 'root', 'f5E7fbJtKugRyMvP', {
//     host: 'localhost',
//     dialect: 'mysql'
//   });

//  const Packagings =  sequelize.define('packagings',{
//     packaging_name: {
//         type : DataTypes.CHAR,
//         allowNull : true
//     }   ,
//     'packaging_id' :{
//         type: DataTypes.NUMBER,
//         primaryKey : true
//     },
//     'initial_stocks' :{
//         type : DataTypes.NUMBER
//     },
//     total :{
//         type: DataTypes.VIRTUAL,
//         get(){
//            return this.getDataValue('initial_stocks') + 10
//         }
//     }
//  },{
//     timestamps : false
//  })

//  const ReleasedP = sequelize.define('released_packagings',{
//         'id' :{
//             type : DataTypes.NUMBER,
//             primaryKey : true
//         },
//         'quantity_released' :{
//             type : DataTypes.NUMBER
//         }
//  },{
//     timestamps : false
//  })

// Packagings.hasMany(ReleasedP,{
//     foreignKey : 'packaging_id',
//     as : 'instances'
// })
// ReleasedP.belongsTo(Packagings,{
//     foreignKey : 'packaging_id'
// })

// async function fetch(){
//    const result = await Packagings.findAll({
//     where :{ 'packaging_id' : 5},
//     include : 'instances'
//    })
//    console.log(JSON.stringify(result))
// }

// fetch()
