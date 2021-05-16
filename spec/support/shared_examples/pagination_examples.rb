# frozen_string_literal: true

shared_examples 'filtering' do |_type, create_record|
  let!(:new_tag) { 'New' }

  context 'when one param is passed' do
    it 'returns the right record' do
      described_class::FILTER_PARAMS.map do |param|
        params = {}
        params[param] = "#{new_tag} #{param}"

        record = create_record.call(params, param)

        get :index, params: params

        expect(response_body[:items]).to eq([record.decorate.as_json])
      end
    end
  end

  context 'when all params are passed' do
    let!(:params) do
      described_class::FILTER_PARAMS.index_with do |param|
        "#{new_tag} #{param}"
      end.to_h
    end

    let!(:record) do
      create_record.call(params)
    end

    it 'returns the right record' do
      get :index, params: params

      expect(response_body[:items]).to eq([record.decorate.as_json])
    end
  end
end
