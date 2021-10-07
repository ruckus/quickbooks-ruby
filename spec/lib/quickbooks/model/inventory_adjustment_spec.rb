# frozen_string_literal: true

require 'nokogiri'

describe 'Quickbooks::Model::InventoryAdjustment' do
  it 'validates basic setup' do
    inventory_adjustment = Quickbooks::Model::InventoryAdjustment.new

    inventory_adjustment.id = 1
    inventory_adjustment.sync_token = 0
    inventory_adjustment.doc_number = 'test DNum'
    inventory_adjustment.private_note = 'Private note'
    inventory_adjustment.txn_date = '2021-05-27 16:52:20 UTC'
    line_item = Quickbooks::Model::Line.new
    line_item.detail_type = 'ItemAdjustmentLineDetail'
    line_item.inventory_adjustment!
    line_item.item_adjustment_line_detail.qty_diff = -2
    line_item.item_adjustment_line_detail.item_ref = { "name": 'item17', "value": '21' }
    inventory_adjustment.line_items << line_item

    n = Nokogiri::XML(inventory_adjustment.to_xml.to_s)
    expect(n.at('InventoryAdjustment > Line > DetailType').content).to eq('ItemAdjustmentLineDetail')
    expect(n.at('Line > ItemAdjustmentLineDetail > QtyDiff').content).to eq('-2')
    expect(inventory_adjustment.valid?).to be true
  end

  it 'validates basic setup for shipping adj' do
    inventory_adjustment = Quickbooks::Model::InventoryAdjustment.new

    inventory_adjustment.id = 1
    inventory_adjustment.sync_token = 0
    inventory_adjustment.doc_number = 'test DNum'
    inventory_adjustment.private_note = 'Private note'
    inventory_adjustment.txn_date = '2021-05-27 16:52:20 UTC'
    inventory_adjustment.shipping_adjustment = true
    line_item = Quickbooks::Model::Line.new
    line_item.detail_type = 'ItemAdjustmentLineDetail'
    line_item.inventory_adjustment!
    line_item.item_adjustment_line_detail.qty_diff = -2
    line_item.item_adjustment_line_detail.sales_price = 10.0
    line_item.item_adjustment_line_detail.item_ref = { "name": 'item17', "value": '21' }
    inventory_adjustment.line_items << line_item

    n = Nokogiri::XML(inventory_adjustment.to_xml.to_s)
    expect(n.at('InventoryAdjustment > Line > DetailType').content).to eq('ItemAdjustmentLineDetail')
    expect(n.at('Line > ItemAdjustmentLineDetail > QtyDiff').content).to eq('-2')
    expect(n.at('Line > ItemAdjustmentLineDetail > SalesPrice').content).to eq('10.0')
    expect(inventory_adjustment.valid?).to be true
  end

  it 'creates an entity reference' do
    inventory_adjustment = Quickbooks::Model::InventoryAdjustment.new
    line_item = Quickbooks::Model::Line.new
    line_item.detail_type = 'ItemAdjustmentLineDetail'
    line_item.inventory_adjustment!
    line_item.item_adjustment_line_detail.qty_diff = -2
    line_item.item_adjustment_line_detail.item_ref = { "name": 'item17', "value": '21' }
    customer_ref = Quickbooks::Model::BaseReference.new(1, name: 'James Rockenstall')

    inventory_adjustment.customer_ref = customer_ref
    inventory_adjustment.line_items << line_item
    n = Nokogiri::XML(inventory_adjustment.to_xml.to_s)
    expect(n.at('InventoryAdjustment > CustomerRef').content).to eq('1')
    expect(n.at('InventoryAdjustment > CustomerRef')[:name]).to eq('James Rockenstall')
  end

  it 'parse from XML' do
    xml = fixture('inventory_adjustment.xml')
    item = Quickbooks::Model::InventoryAdjustment.from_xml(xml)
    expect(item.id).to eq('450')
    expect(item.doc_number).to eq('49')
    expect(item.private_note).to eq('Adjustment for XYZ')
  end

  it 'parse from XML for shipment' do
    xml = fixture('inventory_adjustment_shipment.xml')
    item = Quickbooks::Model::InventoryAdjustment.from_xml(xml)
    expect(item.id).to eq('450')
    expect(item.doc_number).to eq('49')
    expect(item.shipping_adjustment).to eq('true')
    expect(item.private_note).to eq('Adjustment for XYZ')
  end
end
