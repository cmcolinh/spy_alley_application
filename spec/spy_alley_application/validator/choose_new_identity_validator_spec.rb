# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator::ChooseNewIdentityValidator do
  describe '#call' do
    let(:validate){
      SpyAlleyApplication::Validator::ChooseNewIdentityValidator::new(
        nationality_options: ['french', 'german']
      )
    }
    it 'will validate correctly when choosing a valid new identity' do
      expect(validate.(player_action: 'choose_spy_identity', nationality: 'french')).to be_success
    end

    it "will fail if you choose any action other than 'choose_spy_identity'" do
      expect(validate.(player_action: 'invalid', nationality: 'french')).to be_failure
    end

    it 'will fail if you choose an invalid nationality' do
      expect(validate.(player_action: 'choose_spy_identity', nationality: 'russian')).to be_failure
    end

    it 'will fail if you fail to specify a nationality' do
      expect(validate.(player_action: 'choose_spy_identity')).to be_failure
    end

    it 'will fail if you specify multiple nationalities' do
      expect(validate.(player_action: 'choose_spy_identity', nationality: ['french', 'german'])).to be_failure
    end
  end
end

