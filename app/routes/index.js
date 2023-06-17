//Import express routing modules
const express = require('express');
const router = express.Router();

//Controller imports

//Packaging
const Packaging = require('../controllers/packaging.controller')

//Products
const Product = require('../controllers/products.controller')

//Sales
const Sales = require('../controllers/sales.controller')



/*******************   REGISTER YOUR ROUTES HERE! ********************* */

//Packaging routes
router.get('/api/getpackagings', Packaging.fetchPackagingDatas)




//Product routes
router.get('/api/getproducts', Product.fetchProductsData)


//Sales Routes
router.get('/api/getsales', Sales.fetchSalesDatas)





module.exports = router;