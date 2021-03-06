defmodule Execs.DbClient.Client do
  @moduledoc """
  Data manipulation is handled through clients which implement this interface. Like GenServer,
  however, there are some sensible defaults provided for certain callbacks so be sure to add
  'use Execs.DbClient.Client' to the top of your module instead of using the @behaviour tag.
  
  Those callbacks with defaults defined are explicitely called out below.
  """

  @opaque id :: integer()
  @type component :: atom()
  @type component_list :: [component]
  @type component_match :: %{id: id, components: %{component => boolean()}}
  @type component_match_list :: [component_match]
  @type entity :: %{id: id, components: %{component => kv_pairs}}
  @type entity_list :: [entity]
  @type key :: any()
  @type key_match :: %{id: id, components: %{component => %{key => boolean()}}}
  @type key_match_list :: [key_match]
  @type kv_pairs :: map()
  @type id_list :: [id]
  @type id_match :: %{id: id, result: boolean()}
  @type id_match_list :: [id_match]
  @type fun_list :: [fun()]
  @type key_list :: [key]
  @type list_keys :: %{id: id, components: %{component => [key]}}
  @type list_keys_list :: [list_keys]
  @type list_components :: %{id: id, components: component_list}
  @type list_components_list :: [list_components]
  @type maybe_component_list :: component | component_list
  @type maybe_component_match_list :: component_match | component_match_list
  @type maybe_entity_list :: entity | entity_list
  @type maybe_fun_list :: fun | fun_list
  @type maybe_id_list :: id | id_list
  @type maybe_id_match_list :: id_match | id_match_list
  @type maybe_key_list :: key | key_list
  @type maybe_key_match_list :: key_match | key_match_list
  @type maybe_list_components_list :: list_components | list_components_list
  @type maybe_list_keys_list :: list_keys | list_keys_list

  @doc """
  Setup the schema for the database.
  
  If this callback is not implemented, the default callback performs no action.
  """
  @callback create_schema() :: any()

  @doc """
  Delete the schema for the database.
  
  If this callback is not implemented, the default callback performs no action.
  """
  @callback create_schema() :: any()

  @doc """
  Create the tables for the database.
  
  If this callback is not implemented, the default callback performs no action.
  """
  @callback create_tables() :: any()

  @doc """
  Drop the tables for the database.
  
  If this callback is not implemented, the default callback performs no action.
  """
  @callback drop_tables() :: any()

  @doc """
  Called when Execs is starting. Provides a hook to ensure any required
  applications have been started and/or any setup has a chance to be
  performed.
  
  If this callback is not implemented, the default callback performs no action.
  """
  @callback initialize() :: any()

  @doc """
  Called when Execs is shutting down. Provides a hook to ensure any
  required teardown work has been performed.
  
  If this callback is not implemented, the default callback performs no action.
  """
  @callback teardown(any()) :: any()

  @doc """
  Take a function and execute it in the context of a transaction.
  """
  @callback transaction(fun()) :: any()

  @doc """
  Create the specified number of entities and returns the ids.
  """
  @callback create(total :: integer()) :: id_list

  @doc """
  Delete an entity and all its data.
  """
  @callback delete(maybe_id_list) :: maybe_entity_list

  @doc """
  Delete a component and all its data from an entity.
  """
  @callback delete(maybe_id_list, maybe_component_list) :: maybe_entity_list

  @doc """
  Delete a key from a component of an entity.
  """
  @callback delete(maybe_id_list,
                   maybe_component_list,
                   maybe_key_list) :: maybe_entity_list

  @doc """
  Check to see if one or more entities have a component or set of components.
  """
  @callback has_all(maybe_id_list, maybe_component_list) :: id_match_list | boolean()

  @doc """
  Check to see if one or more entities have a key or set of keys..
  """
  @callback has_all(maybe_id_list,
                    maybe_component_list,
                    maybe_key_list) :: id_match_list | boolean()

  @doc """
  Check to see if one or more entities have a value. This is determined by
  passing the value associated with the provided id to the passed in filter
  function and evaluating the boolean result.
  """
  @callback has_all(maybe_id_list,
                    maybe_component_list,
                    maybe_key_list,
                    maybe_fun_list) :: id_match_list | boolean()

  @doc """
  Check to see if one or more entities have a component or set of components.
  """
  @callback has_any(maybe_id_list, maybe_component_list) :: id_match_list | boolean()

  @doc """
  Check to see if one or more entities have a key or set of keys.
  """
  @callback has_any(maybe_id_list,
                    maybe_component_list,
                    maybe_key_list) :: id_match_list | boolean()

  @doc """
  Check to see if one or more entities have a value. This is determined by
  passing the value associated with the provided id to the passed in filter
  function and evaluating the boolean result.
  """
  @callback has_any(maybe_id_list,
                    maybe_component_list,
                    maybe_key_list,
                    maybe_fun_list) :: id_match_list | boolean()

  @doc """
  Check to see if one or more entities have a component or set of components.

  Returns a map of the results.
  """
  @callback has_which(maybe_id_list, maybe_component_list) :: maybe_component_match_list

  @doc """
  Check to see if one or more entities have a key or set of keys.

  Returns a map of the results.
  """
  @callback has_which(maybe_id_list,
                      maybe_component_list,
                      maybe_key_list) :: maybe_key_match_list

  @doc """
  Check to see if one or more entities have a value. This is determined by
  passing the value associated with the provided id to the passed in filter
  function and evaluating the boolean result.
  """
  @callback has_which(maybe_id_list,
                      maybe_component_list,
                      maybe_key_list,
                      maybe_fun_list) :: maybe_key_match_list

  @doc """
  List the components of an entity.
  """
  @callback list(maybe_id_list) :: maybe_list_components_list

  @doc """
  List the keys belonging to a component of an entity.
  """
  @callback list(maybe_id_list, maybe_component_list) :: maybe_list_keys_list

  @doc """
  List the entities which have a component or a set of components.
  """
  @callback find_with_all(maybe_component_list) :: id_list

  @doc """
  List the entities which have a key or set of keys.
  """
  @callback find_with_all(maybe_component_list, maybe_key_list) :: id_list

  @doc """
  List the entities which have certain values. This is determined by passing
  the value to the passed in filter function and evaluating the boolean result.

  A `true` result means that the entity which has that particular value will be
  included in the results.
  """
  @callback find_with_all(maybe_component_list,
                          maybe_key_list,
                          maybe_fun_list) :: id_list

  @doc """
  List the entities which have at least one of a set of components.
  """
  @callback find_with_any(maybe_component_list) :: id_list

  @doc """
  List the entities which have at least one of set of keys.
  """
  @callback find_with_any(maybe_component_list, maybe_key_list) :: id_list

  @doc """
  List the entities which have at least one of a set of certain values. This
  is determined by passing the value to the passed in filter function and
  evaluating the boolean result.

  A `true` result means that the entity which has that particular value will be
  included in the results.
  """
  @callback find_with_any(maybe_component_list,
                          maybe_key_list,
                          maybe_fun_list) :: id_list

  @doc """
  Read an entity or set of entities.
  """
  @callback read(maybe_id_list) :: maybe_entity_list

  @doc """
  Read a component or set of component from an entity or set of entities.
  """
  @callback read(maybe_id_list, maybe_component_list) :: maybe_entity_list

  @doc """
  Read a key or set of keys from an entity or set of entities.
  """
  @callback read(maybe_id_list,
                 maybe_component_list,
                 maybe_key_list) :: maybe_entity_list | any()

  @doc """
  Write a value to any combination of ids, components, and entities.
  """
  @callback write(maybe_id_list,
                  maybe_component_list,
                  maybe_key_list,
                  any()) :: maybe_id_list
                  
  @doc false
  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Execs.DbClient.Client
      
      @doc false
      def create_schema, do: :ok
      
      @doc false
      def delete_schema, do: :ok
      
      @doc false
      def create_tables, do: :ok
      
      @doc false
      def drop_tables, do: :ok
      
      @doc false
      def initialize, do: :ok
      
      @doc false
      def teardown(_state), do: :ok

      defoverridable [create_schema: 0,
                      delete_schema: 0,
                      create_tables: 0,
                      drop_tables: 0,
                      initialize: 0,
                      teardown: 1]
    end
  end
end
