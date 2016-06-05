require 'rails_helper'
require 'support/factory_girl'
require 'match_seeder/seeder'

describe MatchSeeder::RoundRobin do
  def rosters_not_played(roster)
    @div.approved_rosters
        .where.not(id: roster.id)
        .where.not(id: roster.home_team_matches.select(:away_team_id))
        .where.not(id: roster.away_team_matches.select(:home_team_id))
  end

  context 'even number of teams' do
    before do
      @div = create(:division)
      @rosters = create_list(:competition_roster, 6, division: @div)

      5.times do
        described_class.seed_round_for(@div.reload)
      end
    end

    it 'creates matches covering all teams' do
      @rosters.each do |roster|
        expect(rosters_not_played roster).to be_empty
      end
    end

    it 'evenly spreads home and away team matches' do
      @rosters.each do |roster|
        expect(roster.home_team_matches.size).to be_within(1).of(roster.away_team_matches.size)
      end
    end
  end

  context 'odd number of teams' do
    before do
      @div = create(:division)
      @rosters = create_list(:competition_roster, 5, division: @div)

      5.times do
        described_class.seed_round_for(@div.reload)
      end
    end

    it 'creates matches covering all teams' do
      @rosters.each do |roster|
        expect(rosters_not_played roster).to be_empty
      end
    end

    it 'evenly spreads home and away team matches' do
      pending
      @rosters.each do |roster|
        expect(roster.home_team_matches.size).to be_within(1).of(roster.away_team_matches.size)
      end
    end
  end
end
