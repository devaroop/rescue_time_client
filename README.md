# rescue_time_client
A ruby gem to ease integrate with RescueTime API using OAuth2

##Installation

Will publish the gem soon to rubygems, till then:

Add this to your Gemfile:
```ruby
gem 'rescue_time_client'
```

## Creating a client

```ruby
require 'rescue_time_client'

cl = RescueTime::Client.new('your_client_id', 'your_client_secret', 'your_callback_url (exact match)')
```
*Note: This step is necessary for any interaction with the gem*


## Authenticating a user

```ruby
auth_url = cl.get_auth_url(["scope1","scope2",...]) #add your required scopes in the array
```
Redirect user to the ```auth_url``` on the browser. After authenticating, RescueTime will return to your callback_url with a ```code```. Pass the code to get access_token as below.

```ruby
token = cl.get_token_from_code('code_from_above')
```
You may store the token for future purposes and continue making API calls.

Note: Currently RescueTime tokens do not expire.


## Initializing user from token

When you want to initialize user from a token stored somewhere, use:

```ruby
cl.set_token('token_from_db')
```

## Making API calls

The gem makes dynamic calls to the API. Anything starting with ```fetch_``` is a dynamic API call. For e.g.:

```ruby
cl.fetch_daily_summary_data({param1: "something", param2: "other"}) #calls the daily_summary_data endpoint with the params
cl.fetch_productivity_data({param1: "something", param2: "other"}) #calls the productivity_data endpoint with the params
```
Thats how you can call any API endpoint. All API's return data in **json** format. RescueTime supports no other format as of today except for *csv* which is beyond the scope of this gem. ```format: 'json'``` is automatically appended for every API request made.

*Note-1: The _token_ should be set to make API calls.*

*Note-2: All endpoints should be prefixed with ```fetch_``` without which it will raise a NoMethodError*


##Contribution

Please feel free to fork and add pull requests.
