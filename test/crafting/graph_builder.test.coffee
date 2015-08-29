###
Crafting Guide - crafting_node.test.coffee

Copyright (c) 2015 by Redwood Labs
All rights reserved.
###

fixtures     = require './fixtures'
ItemSlug     = require '../../src/coffee/models/item_slug'

########################################################################################################################

builder = null

########################################################################################################################

describe 'GraphBuilder.coffee', ->

    beforeEach ->
        builder = fixtures.makeGraphBuilder()

    describe 'expand', ->

        it 'can work a few steps at a time', ->
            builder.wanted.add ItemSlug.slugify 'test__iron_sword'
            builder.expandGraph 9

            builder.rootNode.depth.should.equal 6
            builder.rootNode.size.should.equal 13
            builder.complete.should.be.false

            builder.expandGraph 9

            builder.rootNode.depth.should.equal 8
            builder.rootNode.size.should.equal 18
            builder.complete.should.be.true

        it 'works properly with an empty inventory', ->
            builder.expandGraph 100

            builder.rootNode.depth.should.equal 1
            builder.rootNode.size.should.equal 1
            builder.complete.should.be.true

        describe 'can build a tree for', ->

            runSingleItemTreeBuildingTest = (slug, depth, size)->
                builder.wanted.add ItemSlug.slugify slug
                builder.expandGraph 100

                builder.rootNode.depth.should.equal depth
                builder.rootNode.size.should.equal size
                builder.complete.should.be.true

            it 'a gatherable item', ->
                runSingleItemTreeBuildingTest 'test__oak_wood', 2, 2

            it 'a single-step item', ->
                runSingleItemTreeBuildingTest 'test__crafting_table', 6, 6

            it 'an item with multiple inputs', ->
                runSingleItemTreeBuildingTest 'test__lever', 8, 9

            it 'can make a tree for an item with multiple recipes', ->
                runSingleItemTreeBuildingTest 'test__iron_ingot', 6, 11

            it 'can make a tree for an item with multiple inputs and multiple recipes', ->
                runSingleItemTreeBuildingTest 'test__iron_sword', 8, 18
                logger.debug builder.toString()