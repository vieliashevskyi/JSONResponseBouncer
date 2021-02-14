# JSONResponseBouncer

## General
Small custom json model validator written in Swift that leverages Swift reflection system.

Allows to map your custom API endpoint with certain expected json models and verify their integrity upon retrieval from server.

System supports validation of following types: 
* String
* NSNumber
* Boolean
* Array<Any>
* Dictionary<String, Any>

Handy to catch differences between expected model on client side and what arrives from server. Saves a lot of time during rapid development phase. Performed well on two mobile games so far.

## Tests and Logger Output
System is fully tested and does not require additional unit tests upon integration. Shipped along with custom logger that visually displays all divergencies that occur during runtime.

![Existing unit tests](/Img/JSONResponseBouncer-tests.png)

## Usage
* Drag-and-Drop files to your repository
* Make sure your model conforms to **Verifiable** protocol
* Define your model. For example head to **TestPlayerModel** inside **JSONResponseBouncerTests.swift** file
* Map your API endpoints to appropriate models inside **JSONBouncerMapper.validate** function.
* You are all set up
