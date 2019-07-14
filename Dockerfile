# Extend from the official Elixir image
FROM elixir:latest

RUN mkdir /app
COPY mix.exs /app/mix.exs

WORKDIR /app

RUN mix local.rebar --force && \
		mix local.hex --force && \
	  mix deps.get && \
		mix deps.compile

COPY . /app		


