
type Map<K, V> = {[K]: V};
type AnyMap = Map<any, any>;
type Dict<V> = {[string]: V};
type Action = () -> void;
type Func<TResult> = () -> TResult;
type void = nil;

type RandomSphereNoun = { str: string; flags: { OF: boolean?, PREPOS: boolean?, PRE: boolean? }? }
type Weighted = { weight: number }

type UnitResult = { good: boolean, info: string }



-- .darklua*.json5
declare DEBUG: boolean;

-- g_src/lua.cpp

-- globals.lua
declare debug_level: number;
declare evil_spheres: {string};
declare good_spheres: {string};
declare random_sphere_adjective: Dict<{string}>;
declare random_sphere_nouns: Dict<{RandomSphereNoun}>;

-- generators.lua
declare languages: any;
declare preprocess: Dict<Action>;
declare do_once_early: Dict<Action>;
declare do_once: Dict<Action>;
declare postprocess: Dict<Action>;
declare unittests: Map<string, Func<UnitResult>>;
declare materials: {
    divine: {
        metal: Dict<string>;
        silk: Dict<string>;
    };
    clouds: Dict<string>;
    rain: Dict<string>;
    mythical_remnant: Dict<string>;
    mythical_healing: Dict<string>;
};
declare items: {
    instruments: {
        keyboard: Dict<string>;
        stringed: Dict<string>;
        wind: Dict<string>;
        percussion: Dict<string>;
    };
};
declare creatures: {
    fb: Dict<string>;
    titan: Dict<string>;
    demon: Dict<string>;
    night_creature: {
        troll: Dict<string>;
        vampire: Dict<string>;
        werebeast: Dict<string>;
        ghost: Dict<string>;
        walking_dead_thinking: Dict<string>;
        walking_dead_dumb_animated: Dict<string>;
        water: Dict<string>;
        stalker: Dict<string>;
        animated: Dict<string>;
        bogeyman: Dict<string>;
        ocean: Dict<string>;
        natural: Dict<string>;
        constructed: Dict<string>;
        sorcerer: Dict<string>;
        royal: Dict<string>;
        nightmare: Dict<string>;
    };
    experiment: {
        humanoid: Dict<string>;
        humanoid_giant: Dict<string>;
        beast_small: Dict<string>;
        beast_large: Dict<string>;
        failed_small: Dict<string>;
        failed_large: Dict<string>;
    };
    angel: {
        humanoid_warrior: Dict<string>;
        humanoid_generic: Dict<string>;
        great_beast: Dict<string>;
    };
};
declare interactions: {
    underground_special: Dict<string>;
    regional: Dict<string>;
    secrets: Dict<string>;
    disturbance: Dict<string>;
    blessing: {
        minor: Dict<string>;
        medium: Dict<string>;
        major: Dict<string>;
    };
    curse: {
        minor: Dict<string>;
        medium: Dict<string>;
        major: Dict<string>;
    };
    bogeyman: Dict<string>;
    mythical_item_power: Dict<string>;
    mythical: Dict<string>;
};
declare entities: {
    vault_guardian: Dict<string>;
    mythical_guardian: Dict<string>;
};

-- g_src/lua.cpp
declare function trandom(max: number?): number;
declare function lua_log(str: string): void;
declare function utterance(): string;
declare function capitalize_string_words(s: string): string;
declare function capitalize_string_first_word(s: string): string;

-- globals.lua
declare function pick_random<T>(t: {T}): T?;
declare function pick_random_no_replace<T>(t: {T}): T?;
declare function pick_random_conditional<T>(t: {T}, cond: ((number, T, ...any) -> boolean) | string, ...: any): T?;
declare function pick_random_conditional_pairs<T>(t: Dict<T>, cond: ((string, T, ...any) -> boolean) | string, ...: any): string?;
declare function one_in(x: number): boolean;
declare function split_to_lines(tbl: {string}, str: string): {string}
declare function map_merge<T, V>(tbl1: Map<any, T>, tbl2: Map<any, V>): Map<any, T | V>;
declare function table_merge<T, V>(tbl1: {T}, tbl2: {V}): {T | V};
declare function find_in_array_part<T>(tbl: {T}, item: T): boolean;
declare function convert_array_to_set<T>(tbl: {T}): Map<T, boolean>;
declare function add_unique<T>(tbl: {T}, item: T): boolean;
declare function remove_item<T>(tbl: {T}, item: T): void;
declare function pick_random_pairs<T, V>(tbl: Map<T, V>): T;
declare function log(...: any): void;
declare function get_caller_loc_string(): string;
declare function get_debug_logger(level: number?): (...any) -> void;
declare function partial_function<T, K, V>(f: (arg: T, ...K) -> V, arg: T): (...K) -> V;
declare function pick_weighted_from_table<T, V>(tbl: Map<T, V & Weighted>): T?;
declare function log_table(tbl: AnyMap, debug_level: number, nest_level: number?, added_debug_from_nest: number?): void;
declare function print_table(tbl: AnyMap, nest_level: number?);
declare function shallow_copy<K, V>(tbl: Map<K, V>): Map<K, V>;
declare function deep_copy<K, V>(tbl: Map<K, V>): Map<K, V>;
declare function generate_from_list<T>(tbl: {((...T) -> Weighted)}, ...: T): {Weighted};
declare function get_random_sphere_adjective(sph: string): string;
declare function get_random_sphere_noun(sph: string): {RandomSphereNoun};
declare function add_sphere_map()

-- generators.lua
declare function add_generated_info(tbl: {string}): {string}
declare function generate(): void
declare function generate_random_materials(): void
declare function generate_random_items(): void
declare function generate_random_languages(): void
declare function generate_random_creatures(): void
declare function generate_random_interactions(): void
declare function generate_random_entities(): void

