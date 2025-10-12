/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = new Collection({
    "createRule": null,
    "deleteRule": null,
    "fields": [
      {
        "autogeneratePattern": "[a-z0-9]{15}",
        "hidden": false,
        "id": "text3208210256",
        "max": 15,
        "min": 15,
        "name": "id",
        "pattern": "^[a-z0-9]+$",
        "presentable": false,
        "primaryKey": true,
        "required": true,
        "system": true,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "number1456615911",
        "max": null,
        "min": null,
        "name": "jobId",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text1146246647",
        "max": 0,
        "min": 0,
        "name": "referenceId",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text724990059",
        "max": 1000,
        "min": 0,
        "name": "title",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": true,
        "system": false,
        "type": "text"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text1843675174",
        "max": 0,
        "min": 0,
        "name": "description",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2442875294",
        "hidden": false,
        "id": "relation3343123541",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "client",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text1587448267",
        "max": 0,
        "min": 0,
        "name": "location",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_1219621782",
        "hidden": false,
        "id": "relation1874629670",
        "maxSelect": 999,
        "minSelect": 0,
        "name": "tags",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "hidden": false,
        "id": "date1008021896",
        "max": "",
        "min": "",
        "name": "scheduledDate",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
      },
      {
        "hidden": false,
        "id": "select4157092294",
        "maxSelect": 1,
        "name": "jobStatus",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "select",
        "values": [
          "unscheduled",
          "scheduled",
          "inProgress",
          "completed",
          "cancelled"
        ]
      },
      {
        "hidden": false,
        "id": "select2715662852",
        "maxSelect": 1,
        "name": "paymentStatus",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "select",
        "values": [
          "unquoted",
          "quoted",
          "invoiced",
          "paid"
        ]
      },
      {
        "hidden": false,
        "id": "number1749776338",
        "max": null,
        "min": null,
        "name": "quotedPrice",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "number3328140539",
        "max": null,
        "min": null,
        "name": "receivedAmount",
        "onlyInt": false,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_3395098727",
        "hidden": false,
        "id": "relation18589324",
        "maxSelect": 999,
        "minSelect": 0,
        "name": "notes",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_3073759650",
        "hidden": false,
        "id": "relation1204091606",
        "maxSelect": 999,
        "minSelect": 0,
        "name": "attachments",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "cascadeDelete": true,
        "collectionId": "_pb_users_auth_",
        "hidden": false,
        "id": "relation3479234172",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "owner",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "relation"
      },
      {
        "hidden": false,
        "id": "json2601981621",
        "maxSize": 0,
        "name": "materials",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "autodate2990389176",
        "name": "created",
        "onCreate": true,
        "onUpdate": false,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "autodate3332085495",
        "name": "updated",
        "onCreate": true,
        "onUpdate": true,
        "presentable": false,
        "system": false,
        "type": "autodate"
      }
    ],
    "id": "pbc_2409499253",
    "indexes": [],
    "listRule": null,
    "name": "jobs",
    "system": false,
    "type": "base",
    "updateRule": null,
    "viewRule": null
  });

  return app.save(collection);
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2409499253");

  return app.delete(collection);
})
