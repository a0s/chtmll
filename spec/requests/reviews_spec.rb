require 'rails_helper'

describe ReviewsController, :type => :request do
  let(:category1) { create(:category) }
  let(:theme1) { create(:theme, category: category1) }
  let(:theme2) { create(:theme, category: category1) }
  let(:review1) { create(:review, comment: 'aaa bbb') }
  let(:review_theme1) { create(:review_theme, review: review1, theme: theme1, sentiment: -1) }
  let(:review_theme2) { create(:review_theme, review: review1, theme: theme2, sentiment: 0) }

  let(:category2) { create(:category) }
  let(:theme3) { create(:theme, category: category2) }
  let(:review2) { create(:review, comment: 'aaa ccc') }
  let(:review_theme3) { create(:review_theme, review: review2, theme: theme3, sentiment: 1) }

  before :each do
    review_theme1
    review_theme2
    review_theme3
  end

  describe '#index' do
    before { get '/reviews', params: params }

    context 'no params' do
      let(:params) { {} }
      it { expect(response_body.count).to eq(2) }
      it { expect(response_body.map { |h| h['id'] }).to match_array [review1.id, review2.id] }
    end

    context 'filter by category' do
      context '#1' do
        let(:params) { { category_ids: [category1.id] } }
        it { expect(response_body.count).to eq(1) }
        it { expect(response_body.first['id']).to eq(review1.id) }
      end

      context '#2' do
        let(:params) { { category_ids: [category2.id] } }
        it { expect(response_body.count).to eq(1) }
        it { expect(response_body.first['id']).to eq(review2.id) }
      end

      context 'all' do
        let(:params) { { category_ids: [category1.id, category2.id] } }
        it { expect(response_body.count).to eq(2) }
        it { expect(response_body.map { |h| h['id'] }).to match_array [review1.id, review2.id] }
      end
    end

    context 'filter by theme' do
      context '#1' do
        let(:params) { { theme_ids: [theme1.id] } }
        it { expect(response_body.count).to eq(1) }
        it { expect(response_body.first['id']).to eq(review1.id) }
      end

      context '#2' do
        let(:params) { { theme_ids: [theme3.id] } }
        it { expect(response_body.count).to eq(1) }
        it { expect(response_body.first['id']).to eq(review2.id) }
      end

      context 'all' do
        let(:params) { { theme_ids: [theme1.id, theme2.id, theme3.id] } }
        it { expect(response_body.count).to eq(2) }
        it { expect(response_body.map { |h| h['id'] }).to match_array [review1.id, review2.id] }
      end
    end

    context 'filter by comment' do
      context '#1' do
        let(:params) { { comments: ['bb'] } }
        it { expect(response_body.count).to eq(1) }
        it { expect(response_body.first['id']).to eq(review1.id) }
      end

      context '#2' do
        let(:params) { { comments: ['ccc'] } }
        it { expect(response_body.count).to eq(1) }
        it { expect(response_body.first['id']).to eq(review2.id) }
      end

      context 'all' do
        let(:params) { { comments: ['aaa'] } }
        it { expect(response_body.count).to eq(2) }
        it { expect(response_body.map { |h| h['id'] }).to match_array [review1.id, review2.id] }
      end

      context 'none' do
        let(:params) { { comments: ['ddd'] } }
        it { expect(response_body.count).to eq(0) }
      end
    end
  end

  describe '#avg_by_theme' do
    before { get '/reviews/avg_by_theme', params: params }

    context 'no params' do
      let(:params) { {} }
      it { expect(response_body.map { |h| h['theme_id'] }).to match_array [theme1.id, theme2.id, theme3.id] }
      it { expect(response_body).to include('theme_id' => theme1.id, 'avg_sentiment' => -1.0) }
      it { expect(response_body).to include('theme_id' => theme2.id, 'avg_sentiment' => 0.0) }
      it { expect(response_body).to include('theme_id' => theme3.id, 'avg_sentiment' => 1.0) }
    end

    context 'filter by category' do
      context '#1' do
        let(:params) { { category_ids: [category1.id] } }
        it { expect(response_body.map { |h| h['theme_id'] }).to match_array [theme1.id, theme2.id] }
        it { expect(response_body).to include('theme_id' => theme1.id, 'avg_sentiment' => -1.0) }
        it { expect(response_body).to include('theme_id' => theme2.id, 'avg_sentiment' => 0.0) }
      end

      context '#2' do
        # TODO due this is homework only
      end

      context '#3' do
        # TODO due this is homework only
      end
    end

    context 'filter by theme' do
      context '#1' do
        let(:params) { { theme_ids: [theme1.id] } }
        it { expect(response_body.map { |h| h['theme_id'] }).to match_array [theme1.id] }
        it { expect(response_body).to include('theme_id' => theme1.id, 'avg_sentiment' => -1.0) }
      end

      context '#2' do
        # TODO due this is homework only
      end

      context 'all' do
        # TODO due this is homework only
      end
    end

    context 'filter by comment' do
      context '#1' do
        let(:params) { { comments: ['bbb'] } }
        it { expect(response_body.map { |h| h['theme_id'] }).to match_array [theme1.id, theme2.id] }
        it { expect(response_body).to include('theme_id' => theme1.id, 'avg_sentiment' => -1.0) }
        it { expect(response_body).to include('theme_id' => theme2.id, 'avg_sentiment' => 0.0) }
      end

      context '#2' do
        # TODO due this is homework only
      end

      context 'all' do
        # TODO due this is homework only
      end
    end
  end

  describe '#avg_by_category' do
    before { get '/reviews/avg_by_category', params: params }

    context 'no params' do
      let(:params) { {} }
      it { expect(response_body.count).to eq(2) }
      it { expect(response_body).to include('category_id' => category1.id, 'avg_sentiment' => -0.5) }
      it { expect(response_body).to include('category_id' => category2.id, 'avg_sentiment' => 1.0) }
    end

    context 'filter by category' do
      context '#1' do
        let(:params) { { category_ids: [category1.id] } }
        it { expect(response_body.map { |h| h['category_id'] }).to match_array [category1.id] }
        it { expect(response_body).to include('category_id' => category1.id, 'avg_sentiment' => -0.5) }
      end

      context '#2' do
        # TODO due this is homework only
      end

      context '#3' do
        # TODO due this is homework only
      end
    end

    context 'filter by theme' do
      context '#1' do
        let(:params) { { theme_ids: [theme1.id] } }
        it { expect(response_body.map { |h| h['category_id'] }).to match_array [category1.id] }
        it { expect(response_body).to include('category_id' => category1.id, 'avg_sentiment' => -1.0) }
      end

      context '#2' do
        # TODO due this is homework only
      end

      context 'all' do
        # TODO due this is homework only
      end
    end

    context 'filter by comment' do
      context '#1' do
        let(:params) { { comments: ['bbb'] } }
        it { expect(response_body.map { |h| h['category_id'] }).to match_array [category1.id] }
        it { expect(response_body).to include('category_id' => category1.id, 'avg_sentiment' => -0.5) }
      end

      context '#2' do
        # TODO due this is homework only
      end

      context 'all' do
        # TODO due this is homework only
      end
    end
  end

  describe '#create' do
    subject { post '/review', params: params }

    let(:comment) { 'ddd fff mmm' }
    let(:sentiment) { -1 }
    let(:theme_id) { theme3.id }

    let(:params) { { comment: comment, themes: [{ theme_id: theme_id, sentiment: sentiment }] } }
    it { expect { subject }.to change { Review.count }.by(1) }
    describe do
      before { subject }
      it { expect(response_body['id']).to be_present }
      it { expect(response_body['comment']).to eq comment }
      it { expect(response_body['themes'].count).to eq 1 }
      it { expect(response_body['themes'].first['sentiment']).to eq sentiment }
      it { expect(response_body['themes'].first['theme_id']).to eq theme_id }
    end
  end
end
