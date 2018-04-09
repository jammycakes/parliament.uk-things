require 'rails_helper'

RSpec.describe 'collections/_collection' do
  let!(:subcollection) {
    assign(:subcollection,
      double(:subcollection,
        name:     subcollection_name_text,
        graph_id: 'asdf1234',
      )
    )
  }

  let!(:article) {
    assign(:article,
      double(:article,
        article_title:   article_title_text,
        article_summary: article_summary_text,
        graph_id:        'xoxoxox8'
      )
    )
  }

  let!(:collection) {
    assign(:collection,
      double(:collection,
        graph_id:             'test2314',
        name:                 collection_name_text,
        extended_description: collection_extended_description_text,
        subcollections:       [subcollection],
        articles:             [article],
        parents:              [parent_collection]
      )
    )
  }

  let!(:parent_collection) {
    assign(:parent_collection,
      double(:parent_collection,
        name:     'Test parent collection',
        graph_id: 'test1234'
      )
    )
  }

  let!(:root_collections) {
    assign(:root_collections,
      [
        double(:root_collection,
          name:     'Test root collection',
          graph_id: 'zxcvbnmj'
        )
      ]
    )
  }

  let!(:collection_name_text)                 { 'This is a test Collection.' }
  let!(:collection_extended_description_text) { '**This** is a test extended description of a Collection.' }
  let!(:subcollection_name_text)              { 'This is a test subcollection name' }
  let!(:article_title_text)                   { 'This is a test Title.' }
  let!(:article_summary_text)                 { '**This** is an article summary' }

  before(:each) do
    render partial: 'collections/collection', locals: { collection: collection, root_collections: root_collections }
  end

  context 'partials' do
    %w(header main footer).each do |template|
      it "will render the shared/article/#{template} partial" do
        expect(response).to render_template(partial: "shared/article/_#{template}")
      end
    end

    context 'when subcollections or articles exist' do
      it 'will render the shared/article/aside_block link partial' do
        expect(response).to render_template(partial: 'shared/article/_aside_block')
      end
    end

    context 'when neither collections or exist' do
      let!(:collection) {
        assign(:collection,
          double(:collection,
            graph_id:             'test2314',
            name:                 collection_name_text,
            extended_description: collection_extended_description_text,
            subcollections:       [],
            articles:             [],
            parents:              [parent_collection]
          )
        )
      }
      it 'will not render the shared/article/aside_block partial' do
        expect(response).not_to render_template(partial: 'shared/article/_aside_block')
      end
    end

    context 'when root collections exist' do
      it 'will render the shared/article/delimited_collection_links partial' do
        expect(response).to render_template(partial: 'shared/article/_delimited_collection_links', count: 3)
      end
    end

    context 'when root collections do not exist' do
      let!(:root_collections) {
        assign(:root_collections, [])
      }
      it 'will not render the shared/article/delimited_collection_links partial' do
        expect(response).to render_template(partial: 'shared/article/_delimited_collection_links', count: 2)
      end
    end
  end
end
