# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator::MoveValidator do
  describe '#call' do
    let(:validate){
      SpyAlleyApplication::Validator::MoveValidator::new(
        space_options: ['18', '2s']
      )
    }
    it 'will validate correctly when choosing to move to a valid location' do
      expect(validate.(player_action: 'move', space: '18')).to be_success
    end

    it "will fail if you choose any action other than 'move'" do
      expect(validate.(player_action: 'invalid', space: '18')).to be_failure
    end

    it 'will fail if you choose an invalid space to move' do
      expect(validate.(player_action: 'move', space: '20')).to be_failure
    end

    it 'will fail if you fail to specify a space to move' do
      expect(validate.(player_action: 'move')).to be_failure
    end

    it 'will fail if you specify multiple spaces to move' do
      expect(validate.(player_action: 'move', space: ['18', '2s'])).to be_failure
    end
  end
end
