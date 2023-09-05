const sequelize = require("../configs/db.config");

//Defined model
const { Products } = require("../models/product.model");

async function fetchProductsData(req, res) {
  //Fetch product data using raw query
  const [result, metadata] = await sequelize.query(`select * ,
    (select coalesce(sum(po.output_quantity),0) as in from production_outputs po where po.product_id = p.product_id),
    (select coalesce(sum(si.quantity), 0) as out from sales_items si where si.product_id = p.product_id),
    (select coalesce(sum(rp.quantity), 0) as repros from repro_products rp where rp.product_id = p.product_id),
    (p.initial_stocks + (select coalesce(sum(po.output_quantity),0) as in from production_outputs po where po.product_id = p.product_id) -
    (select coalesce(sum(si.quantity), 0) as out from sales_items si where si.product_id = p.product_id) - 
     (select coalesce(sum(rp.quantity), 0) as repros from repro_products rp where rp.product_id = p.product_id)) as current_stocks
    from products p order by p.product_name asc`);

  const current = result.filter(i=>{
    return i.product_id == 2
  })
  res.json(result)
}

//Add New Products
async function AddNewProduct(req, res) {
  //Request bodies
  const { productName, initialStocks, packagingSize } = req.body;

  const newProduct = await Products.create({
    product_name: productName,
    initial_stocks: initialStocks,
    packaging_size: packagingSize,
  });

  //Send query result
  res.status(200).json(newProduct);
}

//Export the functions
module.exports = {
  fetchProductsData,
  AddNewProduct,
};
