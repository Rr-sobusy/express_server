//uuid
const { v4: uuidV4 } = require("uuid");

//import sequelize configs
const sequelize = require("../configs/db.config");

//import the defined models
const { Sales, SalesItems } = require("../models/sales.model");

async function fetchSalesDatas(req, res) {
  //Define relationships

  // Sales has many sales instances/sales_items
  Sales.hasMany(SalesItems, {
    foreignKey: "sales_id",
  });
  SalesItems.belongsTo(Sales, {
    foreignKey: "sales_id",
  });

  const result = await Sales.findAll({
    include: [
      {
        model: SalesItems,
        attributes: [
          "sales_item_id",
          "quantity",
          [
            //Add a virtual column -- product_name coming from products table
            sequelize.literal(
              `(Select product_name from products where product_id = sales_items.product_id)`
            ),
            "productName",
          ],
          [
            //Add a virtual column -- packaging size coming from products table
            sequelize.literal(
              `(Select packaging_size from products where product_id = sales_items.product_id)`
            ),
            "packagingSize",
          ],
        ],
      },
    ],
    //Order the results by sales id descenging
    order: [["sales_id", "desc"]],
  });

  //Forward the datas fetched
  res.json(result);
}

//Add New sales instance with its sales items
async function addNewSales(req, res) {
  // Request bodies
  const { customerName, salesTime, salesDate, salesItems } = req.body;

  // create uuid for identity in changing the stocks flow
  const updateKey = uuidV4();

  //Convert salesItem json to an javascript object
  const itemsArray = JSON.parse(salesItems);

  const result = await Sales.create({
    customer_name: customerName,
  }).then(async function () {
    //Fetch latest Id
    const latestSalesID = await Sales.findOne({
      attributes: ["sales_id"],
      order: [["sales_id", "desc"]],
    });

    //iterate the sales items according to json request and insert to it database
    itemsArray.map(function (items) {
      SalesItems.create({
        sales_id: parseInt(latestSalesID.sales_id, 10),
        product_id: parseFloat(items.productId, 10),
        quantity: parseFloat(items.quantity, 10),
      }).then(function () {
        //Save the updates to stocks changes flow
      });
    });
  });

  //
  res.json("success");
}

async function getTopSoldProducts(req, res) {
  const [result, metaData] =
    await sequelize.query(`select p.product_id ,p.product_name , sum(si.quantity * p.packaging_size) as total_sold from products p 
    left join sales_items si on si.product_id = p.product_id group by p.product_id 
    order by sum(si.quantity * p.packaging_size) desc`);
  res.send(result);
}

async function getSalesPerMonth(req, res) {
  const [result, metadata] = await sequelize.query(`SELECT
  EXTRACT(MONTH FROM ps."createdAt"::date) AS month,
  SUM(si.quantity * p.packaging_size / 1000) AS total_sales
FROM
  product_sales ps 
left join sales_items si on si.sales_id = ps.sales_id 
join products p on p.product_id = si.product_id
where extract(YEAR from ps."createdAt"::date) = '2023'
GROUP BY
  EXTRACT(MONTH FROM  ps."createdAt"::date)
ORDER BY
 month;`);
  res.send(result);
}

async function salesThisWeek(req,res){
  const [result,metadata] = await sequelize.query(`select ps."createdAt"::date as sales_date, sum(si.quantity * p.packaging_size) as sales_this_day from product_sales ps 
  left join sales_items si on si.sales_id = ps.sales_id
  join products p on p.product_id = si.product_id group by sales_date order by sales_date desc limit 7`)

  res.send(result)
}

async function customerStats(req,res){
    const [result,metadata] = await sequelize.query(`select c.customer_id , c.customer_name ,sum(si.quantity * p.packaging_size) as total_bought 
    from customers c 
  join product_sales ps on ps.customer_id = c.customer_id 
  join sales_items si on si.sales_id = ps.sales_id 
  join products p on p.product_id = si.product_id 
  group by c.customer_name, c.customer_id  order by customer_name asc`)
    res.json(result)
}

module.exports = {
  fetchSalesDatas,
  addNewSales,
  getTopSoldProducts,
  getSalesPerMonth,
  customerStats,
  salesThisWeek
};
