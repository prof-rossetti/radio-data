# Radio Data

Generates a related set of .csv files,
 which represent usage data from an online music streaming service.

## Prerequisities

Clone this repository.

```` sh
git clone git@github.com:gwu-business/radio-data.git
cd radio-data/
````

Install ruby and bundler.

Install gem dependencies:

```` sh
bundle install
````

### Environment Variables

Grab an rdio api key (client id and client secret), and add each respective environment variable to .bash_profile:

 + `RADIO_DATA_RDIO_CLIENT_ID`
 + `RADIO_DATA_RDIO_CLIENT_SECRET`

## Usage

Generate data.

```` sh
ruby generate_data.rb
````

## Contributing

Issues and Pull Requests are welcome.

## [License](LICENSE)
